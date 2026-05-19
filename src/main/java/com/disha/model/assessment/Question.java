package com.disha.model.assessment;

import java.util.List;

/**
 * Represents a single assessment question in the DISHA portal.
 * Each question belongs to a specific section (Aptitude, Personality, Interest)
 * and contains a list of selectable answer options.
 * 
 * @author Ashmit
 */
public class Question {

    private int questionId;
    private String questionText;
    /** The assessment section: APTITUDE (Section A), PERSONALITY (Section B), or INTEREST (Section C) */
    private String section;       
    /** The type of input required: MCQ (Multiple Choice) or LIKERT (1-5 scale) */
    private String questionType;  
    /** Sequence number for displaying questions in the correct order */
    private int questionOrder;
    /** The list of available answer choices for this specific question */
    private List<Option> options; 

    public Question() {
    }

    public int getQuestionId() {
        return questionId;
    }

    public void setQuestionId(int questionId) {
        this.questionId = questionId;
    }

    public String getQuestionText() {
        return questionText;
    }

    public void setQuestionText(String questionText) {
        this.questionText = questionText;
    }

    public String getSection() {
        return section;
    }

    public void setSection(String section) {
        this.section = section;
    }

    public String getQuestionType() {
        return questionType;
    }

    public void setQuestionType(String questionType) {
        this.questionType = questionType;
    }

    public int getQuestionOrder() {
        return questionOrder;
    }

    public void setQuestionOrder(int questionOrder) {
        this.questionOrder = questionOrder;
    }

    public List<Option> getOptions() {
        return options;
    }

    public void setOptions(List<Option> options) {
        this.options = options;
    }
}
