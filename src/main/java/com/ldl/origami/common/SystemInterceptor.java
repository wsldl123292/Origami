package com.ldl.origami.common;

import com.ldl.origami.util.Constants;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
* @ClassName: SystemInterceptor
* @Description: 验证登录状态
* @author LDL
* @date 2014年4月18日 下午4:16:15
*
 */
public class SystemInterceptor extends HandlerInterceptorAdapter {

	private static final Logger logger = LoggerFactory.getLogger(SystemInterceptor.class);
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
		throws Exception {
		String urlString = request.getRequestURL().toString();
		logger.debug("当前的URL为: " + urlString);
        HttpSession session = request.getSession(false);
		if(session!=null){

			if(session.getAttribute(Constants.SESSION_USERNAME)!=null){
				return true;
			}else{
				request.getRequestDispatcher("/login").forward(request, response);
				return false;
			}
		}else{
			request.getRequestDispatcher("/login").forward(request, response);
			return false;
		}
	}

}
