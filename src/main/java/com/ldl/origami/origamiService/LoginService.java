package com.ldl.origami.origamiService;

import com.ldl.origami.dao.UserMapper;
import com.ldl.origami.domain.User;
import com.ldl.origami.domain.UserExample;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 功能描述:
 * 作者: LDL
 * 创建时间: 2014/7/15 15:09
 */
@Service
public class LoginService {

    static Logger logger = LoggerFactory.getLogger(LoginService.class);

    @Autowired(required = false)
    private UserMapper userMapper;

    /**
     * 验证登录
     * @param username
     * @param passwd
     * @return
     */
    public String checkLogin(String username,String passwd){
        String result = "";
        UserExample example = new UserExample();
        example.createCriteria().andUserNameEqualTo(username).andUserPasswdEqualTo(passwd);
        try{
            List<User> users = userMapper.selectByExample(example);
            if (users != null) {
                if(users.size()>0){
                    result = "succ";
                }else{
                    result = "fail";
                }
            }else{
                result = "error";
            }
        }catch (Exception e){
            logger.debug(e.getMessage());
            result = "error";
        }

        return result;
    }
}
