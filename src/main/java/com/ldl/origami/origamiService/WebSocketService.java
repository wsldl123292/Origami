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
 * 创建时间: 2014/8/14 10:11
 */
@Service
public class WebSocketService {

    @Autowired(required = false)
    private NewsMapper newsMapper;


    /**
     * 返回用户的未读消息
     *
     * @param userName
     * @return
     */
    public int getUnReadNews(String userName) {
        NewsExample example = new NewsExample();
        example.createCriteria().andUsernameEqualTo(userName).andStateEqualTo(0);
        List<News> news = newsMapper.selectByExample(example);
        return news.size();
    }

}
