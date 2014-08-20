package com.ldl.origami.controller.entity;

import com.ldl.origami.domain.News;
import com.ldl.origami.origamiService.UserService;
import com.ldl.origami.util.Constants;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

/**
 * 功能描述:涉及到用户相关操作的Controller
 * 作者: LDL
 * 创建时间: 2014/8/20 15:07
 */
@Controller
public class UserController {


    @Autowired
    private UserService userService;

    @RequestMapping("/viewNews")
    public ModelAndView viewNews(HttpServletRequest request){
        String userName = (String) request.getSession().getAttribute(Constants.SESSION_USERNAME);
        List<News> newses = userService.getNewsByUserName(userName);
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("newses",newses);
        modelAndView.setViewName("/news/viewNews");
        return modelAndView;
    }

    /**
     * 显示消息内容
     * @return
     */
    @RequestMapping("/newsContent")
    public ModelAndView newsContent(@RequestParam("newsID") int newsId){
        News news = userService.getNewsById(newsId);
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.addObject("news",news);
        modelAndView.setViewName("/news/newsContent");
        return modelAndView;
    }
}
