package com.disha.model.assessment;

/**
 * Represents a single answer choice for an assessment question.
 * Contains the display text and the scoring weight (MCQ or Likert).
 * 
 * @author DISHA Team
 */
public class Option {

    private int optionId;
    private int questionId;
    private String optionText;
    /** For MCQs: 1 or 0. For Likert: 1 (Strongly Disagree) to 5 (Strongly Agree) */
    private int scoreValue;  
    /** Only true for the correct answer in Section A (MCQ) questions */
    private boolean isCorrect;

    public Option() {
    }

    public int getOptionId() {
        return optionId;
    }

    public void setOptionId(int optionId) {
        this.optionId = optionId;
    }

    public int getQuestionId() {
        return questionId;
    }

    public void setQuestionId(int questionId) {
        this.questionId = questionId;
    }

    public String getOptionText() {
        return optionText;
    }

    public void setOptionText(String optionText) {
        this.optionText = optionText;
    }

    public int getScoreValue() {
        return scoreValue;
    }

    public void setScoreValue(int scoreValue) {
        this.scoreValue = scoreValue;
    }

    public boolean isCorrect() {
        return isCorrect;
    }

    public void setCorrect(boolean correct) {
        isCorrect = correct;
    }
}
