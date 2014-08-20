package com.ldl.origami.origamiService;

import com.ldl.origami.dao.NewsMapper;
import com.ldl.origami.domain.News;
import com.ldl.origami.domain.NewsExample;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 功能描述:
 * 作者: LDL
 * 创建时间: 2014/8/20 15:19
 */
@Service
public class UserService {

    @Autowired(required = false)
    private NewsMapper newsMapper;

    /**
     * 根据用户名查询未读消息
     * @param userName
     * @return
     */
    public List<News> getNewsByUserName(String userName){
        NewsExample example = new NewsExample();
        example.createCriteria().andUsernameEqualTo(userName).andStateEqualTo(0);
        example.or().andUsernameEqualTo("ALL").andStateEqualTo(0);
        List<News> newses = newsMapper.selectByExample(example);
        return newses;
    }


    /**
     * 根据消息ID查询消息
     * @param newsId
     * @return
     */
    public News getNewsById(int newsId){
        News news = newsMapper.selectByPrimaryKey(newsId);
        return news;
    }
}
