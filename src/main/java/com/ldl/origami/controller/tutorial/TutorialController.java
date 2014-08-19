package com.ldl.origami.controller.tutorial;

import com.ldl.origami.domain.Tutorial;
import com.ldl.origami.origamiService.TutorialService;
import com.ldl.origami.util.Constants;
import com.ldl.origami.util.ScaleImageUtils;
import org.joda.time.DateTime;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.awt.image.CropImageFilter;
import java.awt.image.FilteredImageSource;
import java.awt.image.ImageFilter;
import java.io.File;
import java.io.IOException;

/**
 * 功能描述:
 * 作者: LDL
 * 创建时间: 2014/7/16 21:31
 */
@Controller
public class TutorialController {

    @Autowired(required = false)
    private TutorialService tutorialService;

    static Logger logger = LoggerFactory.getLogger(TutorialController.class);


    /**
     * 跳转到添加教程页面
     * @param request
     * @return
     */
    @RequestMapping("/addTutorialPage")
    public ModelAndView addTutorialPage(HttpServletRequest request){

        HttpSession session = request.getSession();
        String username = (String) session.getAttribute(Constants.SESSION_USERNAME);
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("username", username);
        modelAndView.setViewName("addTutorial");
        return modelAndView;
    }

    /**
     * 添加教程
     * @param request
     * @return
     */
    @RequestMapping("/addTutorial")
    public ModelAndView addTutorial(HttpServletRequest request){

        HttpSession session = request.getSession();
        String username = (String) session.getAttribute(Constants.SESSION_USERNAME);
        String imgsrc = request.getParameter("imgsrc");
        String titlecontext = request.getParameter("titlecontext");
        String introductioncontext = request.getParameter("introductioncontext");
        String content = request.getParameter("content");
        DateTime dateTime = DateTime.now();

        Tutorial tutorial = new Tutorial();
        tutorial.setUserName(username);
        tutorial.setTitleImgPath(imgsrc);
        tutorial.setTitle(titlecontext);
        tutorial.setIntroduce(introductioncontext);
        tutorial.setContent(content);
        tutorial.setAuditing("N");
        tutorial.setCreateTime(dateTime.toDate());
        String result = tutorialService.saveTutorial(tutorial);
        ModelAndView modelAndView = new ModelAndView();
        if(result.equals("")){
            modelAndView.setViewName("addTutorialSuccess");
        }else{
            modelAndView.addObject("errormsg",result);
            modelAndView.setViewName("error");
        }
        return modelAndView;

    }


    /**
     * 图片上传保存
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/uploadTitleImage")
    @ResponseBody
    public String uploadTitleImage(HttpServletRequest request, HttpServletResponse response) {
        MultipartHttpServletRequest multipartRequest = (MultipartHttpServletRequest) request;
        String path = request.getSession().getServletContext().getRealPath("/upload");
        String result="";

        // 获得文件：
        MultipartFile multipartFile = multipartRequest.getFile("uploadfile");

        DateTime dateTime = new DateTime();
        String str = dateTime.toString("yyyymmddhhmmssSSSS");
        // 获得文件名：
        String fileFullName = multipartFile.getOriginalFilename();
        String fileType = fileFullName.substring(fileFullName.lastIndexOf("."),fileFullName.length());
        logger.debug("FileType:"+fileType);
        String fileName = fileFullName.substring(0,fileFullName.lastIndexOf("."))+str+fileType;
        logger.debug("fileName:"+fileName);
        String savePath = "/imagetemp/" + fileName;
        String filePath = path + savePath;

        result = request.getContextPath() + "/upload" + savePath;
        try {
            ScaleImageUtils.resize(400,400,filePath,multipartFile.getInputStream());
        } catch (IOException e) {
            result = "上传失败"+e.getMessage();
            e.printStackTrace();
        }
        logger.debug("filePath: " + filePath);
        /*File file = new File(filePath);
        if (!file.exists()) {
            file.mkdirs();
        }
        try {
            multipartFile.transferTo(file);
        } catch (IOException e) {
            e.printStackTrace();
        }*/
        return result;
    }

    /**
     * 生成略缩图
     *
     * @param request
     * @param response
     * @return
     */
    @RequestMapping(value = "/thumbnailimage")
    @ResponseBody
    public String uploadthumbnailimage(HttpServletRequest request, HttpServletResponse response) {
        int x = Integer.parseInt(request.getParameter("x1"));
        int y = Integer.parseInt(request.getParameter("y1"));
        int h = Integer.parseInt(request.getParameter("h"));
        int w = Integer.parseInt(request.getParameter("w"));
        String oldpath = request.getParameter("oldpath").replace(request.getContextPath(), "");
        String path = request.getSession().getServletContext().getRealPath(oldpath);
        String fileName = oldpath.substring(oldpath.lastIndexOf("/") + 1, oldpath.length());
        String dirImageFileUrl = request.getSession().getServletContext().getRealPath("/upload") + "/title/title_" + fileName;
        String showUrl = request.getContextPath()+"/upload/title/title_" + fileName;
        logger.debug("showUrl:" + showUrl);
        // 读取源图像
        try {
            Image img;
            ImageFilter cropFilter;
            BufferedImage bi = ImageIO.read(new File(path));
            int srcWidth = bi.getWidth(); // 源图宽度
            int srcHeight = bi.getHeight(); // 源图高度
            if (srcWidth >= w && srcHeight >= h) {
                Image image = bi.getScaledInstance(srcWidth, srcHeight,
                        Image.SCALE_DEFAULT);
                cropFilter = new CropImageFilter(x, y, w, h);
                img = Toolkit.getDefaultToolkit().createImage(
                        new FilteredImageSource(image.getSource(), cropFilter));
                BufferedImage tag = new BufferedImage(w, h,
                        BufferedImage.TYPE_INT_RGB);
                Graphics g = tag.getGraphics();
                g.drawImage(img, 0, 0, null); // 绘制缩小后的图
                g.dispose();

                File dirImageFile = new File(dirImageFileUrl);
                if(!dirImageFile.exists()){
                    dirImageFile.mkdirs();
                }
                // 输出为文件
                ImageIO.write(tag, "JPEG", dirImageFile);
            }
            File file = new File(path);
            file.delete();
        } catch (IOException e) {
            e.printStackTrace();
        }
        return showUrl;
    }
}
