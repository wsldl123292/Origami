package com.ldl.origami.dao;

import com.ldl.origami.domain.Tutorial;
import com.ldl.origami.domain.TutorialExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface TutorialMapper {
    int countByExample(TutorialExample example);

    int deleteByExample(TutorialExample example);

    int deleteByPrimaryKey(Integer id);

    int insert(Tutorial record);

    int insertSelective(Tutorial record);

    List<Tutorial> selectByExampleWithBLOBs(TutorialExample example);

    List<Tutorial> selectByExample(TutorialExample example);

    Tutorial selectByPrimaryKey(Integer id);

    int updateByExampleSelective(@Param("record") Tutorial record, @Param("example") TutorialExample example);

    int updateByExampleWithBLOBs(@Param("record") Tutorial record, @Param("example") TutorialExample example);

    int updateByExample(@Param("record") Tutorial record, @Param("example") TutorialExample example);

    int updateByPrimaryKeySelective(Tutorial record);

    int updateByPrimaryKeyWithBLOBs(Tutorial record);

    int updateByPrimaryKey(Tutorial record);
}