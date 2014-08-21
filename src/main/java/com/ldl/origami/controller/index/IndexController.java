package com.ldl.origami.controller.index;

import com.ldl.origami.domain.Tutorial;
import com.ldl.origami.domain.User;
import com.ldl.origami.origamiService.IndexService;
import com.ldl.origami.util.Constants;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 功能描述:
 * 作者: LDL
 * 创建时间: 2014/7/16 21:08
 */
@Controller
public class IndexController {

    static Logger logger = LoggerFactory.getLogger(IndexController.class);
    @Autowired(required = false)
    private IndexService indexService;

    @RequestMapping("/index")
    public ModelAndView index(HttpServletRequest request) {

        HttpSession session = request.getSession();
        String username = (String) session.getAttribute(Constants.SESSION_USERNAME);
        List<Tutorial> tutorials = indexService.getAllTutorialsWithThroughTheAudit();
        Map<Integer,Tutorial> tutorialsMap = new HashMap<Integer, Tutorial>();
        for(int i = 0;i<tutorials.size();i++){
            tutorialsMap.put(tutorials.get(i).getId(),tutorials.get(i));
        }
        session.setAttribute(Constants.SESSION_TUTORIALS,tutorialsMap);

        User user = new User();
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("tutorials", tutorials);
        if(username==null||username.equals("")){
            user = null;
        }else{
            user = indexService.getUserByName(username);
            session.setAttribute(Constants.SESSION_USER, user);
        }
        modelAndView.addObject("user",user);
        modelAndView.setViewName("index");
        return modelAndView;
    }

    /**
     * 查看教程内容
     * @param request
     * @return
     */
    @RequestMapping("/viewTheContents")
    public ModelAndView viewTheContents(HttpServletRequest request){

        HttpSession session = request.getSession();
        int id = Integer.parseInt(request.getParameter("id"));
        HashMap<Integer, Tutorial> tutorialHashMap = (HashMap<Integer, Tutorial>) session.getAttribute(Constants.SESSION_TUTORIALS);
        Tutorial tutorial = tutorialHashMap.get(id);
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("tutorial", tutorial);
        modelAndView.setViewName("viewTheContents");
        return modelAndView;
    }

}
