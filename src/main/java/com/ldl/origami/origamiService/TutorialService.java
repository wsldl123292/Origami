package com.ldl.origami.origamiService;

import com.ldl.origami.dao.TutorialMapper;
import com.ldl.origami.domain.Tutorial;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * 功能描述:
 * 作者: LDL
 * 创建时间: 2014/7/19 20:50
 */
@Service
public class TutorialService {

    static org.slf4j.Logger logger = LoggerFactory.getLogger(TutorialService.class);
    @Autowired(required = false)
    private TutorialMapper tutorialMapper;



    public String saveTutorial(Tutorial tutorial){
        String result = "";
        try{
            tutorialMapper.insert(tutorial);
        }catch (Exception e){
            result = "保存教程失败";
            logger.error("保存教程失败:"+e);
        }
        return result;
    }
}
