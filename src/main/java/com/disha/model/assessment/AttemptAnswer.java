package com.disha.model.assessment;

/**
 * Represents a single answer recorded during an assessment attempt.
 * Links an assessment attempt to a specific question and the option 
 * selected by the student.
 * 
 * @author Ashmit
 */
public class AttemptAnswer {

    private int answerId;
    private int attemptId;
    private int questionId;
    private int selectedOptionId;

    public AttemptAnswer() {
    }

    public int getAnswerId() {
        return answerId;
    }

    public void setAnswerId(int answerId) {
        this.answerId = answerId;
    }

    public int getAttemptId() {
        return attemptId;
    }

    public void setAttemptId(int attemptId) {
        this.attemptId = attemptId;
    }

    public int getQuestionId() {
        return questionId;
    }

    public void setQuestionId(int questionId) {
        this.questionId = questionId;
    }

    public int getSelectedOptionId() {
        return selectedOptionId;
    }

    public void setSelectedOptionId(int selectedOptionId) {
        this.selectedOptionId = selectedOptionId;
    }
}
