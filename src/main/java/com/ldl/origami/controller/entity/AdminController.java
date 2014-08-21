package com.ldl.origami.controller.entity;

import com.ldl.origami.domain.News;
import com.ldl.origami.domain.Tutorial;
import com.ldl.origami.origamiService.AdminService;
import com.ldl.origami.util.Constants;
import com.ldl.origami.websocket.SystemWebSocketHandler;
import org.joda.time.DateTime;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.socket.TextMessage;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.List;

/**
 * 功能描述:
 * 作者: LDL
 * 创建时间: 2014/7/31 15:17
 */
@Controller
public class AdminController {

    static Logger logger = LoggerFactory.getLogger(AdminController.class);

    @Autowired(required = false)
    private AdminService adminService;

    @Bean
    public SystemWebSocketHandler systemWebSocketHandler() {
        return new SystemWebSocketHandler();
    }

    @RequestMapping("/adminLoginIndex")
    public String adminLoginIndex(){
        return "adminLogin";
    }

    /**
     * 验证登录
     *
     * @param request
     * @return
     */
    @RequestMapping("/checkAdminLogin")
    @ResponseBody
    public String checkLogin(HttpServletRequest request) {
        String result = "";
        String name = request.getParameter("userName");
        String passwd = request.getParameter("passwd");
        result = adminService.checkLogin(name, passwd);
        if (result.equals("succ")) {
            HttpSession session = request.getSession();
            session.setAttribute(Constants.SESSION_ADMIN, name);
        }
        return result;
    }
    /**
     * 管理员主页
     *
     * @param request
     * @return
     */
    @RequestMapping("/adminIndex")
    public ModelAndView adminIndex(HttpServletRequest request) {
        List<Tutorial> unauditedTutorials = adminService.getAllUnauditedTutorials();
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("unauditedTutorials", unauditedTutorials);
        modelAndView.setViewName("adminIndex");
        return modelAndView;
    }


    /**
     * 查看教程内容
     * @param request
     * @return
     */
    @RequestMapping("/adminViewTheContents")

    public ModelAndView adminViewTheContents(HttpServletRequest request) {

        int id = Integer.parseInt(request.getParameter("id"));
        Tutorial tutorial = adminService.getTutorialById(id);
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("tutorial", tutorial);
        modelAndView.setViewName("adminViewTheContents");
        return modelAndView;
    }

    /**
     * 审核教程
     * @param request
     * @return
     */
    @RequestMapping("/auditing")
    @ResponseBody
    public String auditing(HttpServletRequest request){
        String result = "fail";
        int id = Integer.parseInt(request.getParameter("id"));
        String reason = request.getParameter("reason");
        String title = request.getParameter("title");
        String username = request.getParameter("username");
        News news = new News();
        DateTime dateTime = DateTime.now();
        news.setNewsTime(dateTime.toDate());
        news.setState(0);
        news.setUsername(username);
        if(reason.equals("")){
            //审核通过
            result = adminService.auditingById(id,"Y");
            news.setNewsTitle("审核通过");
            news.setNewsContent(String.format(Constants.AUDIT_MESSAGE, username, title, reason));
            adminService.addNewsWithUnAudit(news);
        }else{
            //审核未通过
            news.setNewsTitle("审核未通过");
            news.setNewsContent(String.format(Constants.UN_AUDIT_MESSAGE,username,title,reason));
            result = adminService.addNewsWithUnAudit(news);
            result = adminService.auditingById(id, "D");
        }
        //SystemServerEndPoint serverEndPoint = new SystemServerEndPoint();
        int unReadNewsCount = adminService.getUnReadNews(username);
        systemWebSocketHandler().sendMessageToUser(username, new TextMessage(unReadNewsCount + ""));
        return result;
    }
}
