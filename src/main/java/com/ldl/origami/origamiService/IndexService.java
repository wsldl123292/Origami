package com.ldl.origami.origamiService;

import com.ldl.origami.dao.TutorialMapper;
import com.ldl.origami.dao.UserMapper;
import com.ldl.origami.domain.Tutorial;
import com.ldl.origami.domain.TutorialExample;
import com.ldl.origami.domain.User;
import com.ldl.origami.domain.UserExample;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 功能描述:
 * 作者: LDL
 * 创建时间: 2014/7/21 21:43
 */
@Service
public class IndexService {

    @Autowired(required = false)
    private TutorialMapper tutorialMapper;

    @Autowired(required = false)
    private UserMapper userMapper;

    /**
     * 获取通过审核的所有教程
     * @return
     */
    public List<Tutorial> getAllTutorialsWithThroughTheAudit(){

        TutorialExample example = new TutorialExample();
        example.createCriteria().andAuditingEqualTo("Y");
        example.setOrderByClause("CREATE_TIME DESC");
        List<Tutorial> tutorials = tutorialMapper.selectByExampleWithBLOBs(example);
        return tutorials;

    }


    public User getUserByName(String userName){
        UserExample example = new UserExample();
        example.createCriteria().andUserNameEqualTo(userName);
        User user = userMapper.selectByExample(example).get(0);
        return user;
    }
}
