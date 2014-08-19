package com.ldl.origami.origamiService;

import com.ldl.origami.dao.NewsMapper;
import com.ldl.origami.dao.TutorialMapper;
import com.ldl.origami.dao.UserMapper;
import com.ldl.origami.domain.*;
import org.joda.time.DateTime;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

/**
 * 功能描述:
 * 作者: LDL
 * 创建时间: 2014/7/15 15:09
 */
@Service
public class AdminService {

    static Logger logger = LoggerFactory.getLogger(AdminService.class);

    @Autowired(required = false)
    private UserMapper userMapper;

    @Autowired(required = false)
    private TutorialMapper tutorialMapper;

    @Autowired(required = false)
    private NewsMapper newsMapper;

    public AdminService(){
        System.out.println("adminservice");
    }


    /**
     * 验证登录
     * @param username
     * @param passwd
     * @return
     */
    public String checkLogin(String username,String passwd){
        String result = "";
        if(!username.equals("admin")){
            return "error";
        }
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

    /**
     * 查询所有未审核的教程
     * @return
     */
    public List<Tutorial> getAllUnauditedTutorials(){

        List<Tutorial> unauditedTutorials = new ArrayList<>();
        TutorialExample example = new TutorialExample();
        example.createCriteria().andAuditingEqualTo("N");
        example.setOrderByClause("CREATE_TIME DESC");
        try{
            unauditedTutorials = tutorialMapper.selectByExample(example);
        }catch (Exception e){
            logger.debug(e.getMessage());
        }

        return unauditedTutorials;

    }

    /**
     * 根据id查询教程
     * @param id
     * @return
     */
    public Tutorial getTutorialById(int id){

        TutorialExample example = new TutorialExample();
        Tutorial tutorial = new Tutorial();
        example.createCriteria().andIdEqualTo(id);
        try{
            tutorial = tutorialMapper.selectByExampleWithBLOBs(example).get(0);
        }catch (Exception e){
            logger.debug(e.getMessage());
        }

        return tutorial;

    }
    /**
     * 根据id审核教程
     * @param id
     * @return
     */
    public String auditingById(int id,String type){

        String result = "success";
        TutorialExample example = new TutorialExample();
        Tutorial tutorial = new Tutorial();
        tutorial.setAuditing(type);
        DateTime dateTime = DateTime.now();
        tutorial.setAuditTime(dateTime.toDate());
        example.createCriteria().andIdEqualTo(id);
        try{
            tutorialMapper.updateByExampleSelective(tutorial,example);
        }catch (Exception e){
            result="fail";
            logger.debug(e.getMessage());
        }

        return result;

    }

    /**
     * 添加消息
     * @param news
     * @return
     */
    public String addNewsWithUnAudit(News news){
        String result="success";

        try{
            newsMapper.insert(news);
        }catch (Exception e){
            result = "fail";
            logger.debug(e.getMessage());
        }
        return result;
    }

    /**
     * 返回用户的未读消息
     * @param userName
     * @return
     */
    public int getUnReadNews(String userName){
        NewsExample example = new NewsExample();
        example.createCriteria().andUsernameEqualTo(userName).andStateEqualTo(0);
        List<News> news = newsMapper.selectByExample(example);
        return news.size();
    }
}
