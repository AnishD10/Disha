package com.disha.model.assessment;

public class Option {
    private int optionId;
    private int questionId;
    private String optionText;
    private int scoreValue;
    private boolean correct;

    public int getOptionId() { return optionId; }
    public void setOptionId(int optionId) { this.optionId = optionId; }
    public int getQuestionId() { return questionId; }
    public void setQuestionId(int questionId) { this.questionId = questionId; }
    public String getOptionText() { return optionText; }
    public void setOptionText(String optionText) { this.optionText = optionText; }
    public int getScoreValue() { return scoreValue; }
    public void setScoreValue(int scoreValue) { this.scoreValue = scoreValue; }
    public boolean isCorrect() { return correct; }
    public void setCorrect(boolean correct) { this.correct = correct; }
}
