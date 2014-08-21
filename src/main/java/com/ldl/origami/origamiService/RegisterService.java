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
 * 创建时间: 2014/7/13 12:49
 */
@Service
public class RegisterService {
    static Logger logger = LoggerFactory.getLogger(RegisterService.class);
    @Autowired(required = false)
    private UserMapper userMapper;

    /**
     * 保存用户信息
     * @param user
     * @return
     */
    public String saveUser(User user){
        String result = "";
        try {
            userMapper.insert(user);
            result = "succ";
        }catch (Exception e){
            logger.debug(e.getMessage());
            result = "fail";
        }
        return result;
    }

    /**
     * 检测用户名是否存在
     * @param userName
     * @return
     */
    public String checkUserName(String userName){
        String result = "";
        UserExample example = new UserExample();
        example.createCriteria().andUserNameEqualTo(userName);
        try{
            List<User> users = userMapper.selectByExample(example);
            if(users != null){
                if (users.size() > 0) {
                    result = "no";
                } else {
                    result = "yes";
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

    /**
     * 检测邮箱是否存在
     * @param email
     * @return
     */
    public String checkEmail(String email) {
        String result = "";
        UserExample example = new UserExample();
        example.createCriteria().andUserMailEqualTo(email);
        try {
            List<User> users = userMapper.selectByExample(example);
            if(users != null){
                if (users.size() > 0) {
                    result = "no";
                } else {
                    result = "yes";
                }
            }else {
                result = "error";
            }

        } catch (Exception e) {
            logger.debug(e.getMessage());
            result = "error";
        }

        return result;
    }


}
