package com.ldl.origami.controller.system;

import com.ldl.origami.origamiService.LoginService;
import com.ldl.origami.util.Constants;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

/**
 * 功能描述:
 * 作者: LDL
 * 创建时间: 2014/7/15 14:47
 */
@Controller
public class LoginController {

    static Logger logger = LoggerFactory.getLogger(LoginController.class);

    @Autowired(required = false)
    private LoginService loginService;

    @RequestMapping(value = "/login")
    public String login(){
        return "login";
    }

    /**
     * 验证登录
     * @param request
     * @return
     */
    @RequestMapping("/checkLogin")
    @ResponseBody
    public String checkLogin(HttpServletRequest request){
        String result = "";
        String name = request.getParameter("userName");
        String passwd = request.getParameter("passwd");
        logger.debug("name:"+name);
        logger.debug("passwd:"+passwd);
        result = loginService.checkLogin(name,passwd);
        if(result.equals("succ")){
            HttpSession session = request.getSession();
            session.setAttribute(Constants.SESSION_USERNAME,name);
        }
        return result;
    }

}
