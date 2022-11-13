<template>
  <Survey :survey="survey" />
</template>

<script>
import "survey-core/defaultV2.min.css";
import { StylesManager, Model } from "survey-core";
import { Survey } from "survey-vue-ui";

StylesManager.applyTheme("defaultV2");

const surveyJson = {
  elements: [
    {
      name: "FirstName",
      title: "Enter your first name:",
      type: "text",
    },
    {
      name: "LastName",
      title: "Enter your last name:",
      type: "text",
    },
  ],
};

export default {
  name: "MyFirstSurvey",
  components: {
    Survey,
  },
  data() {
    const survey = new Model(surveyJson);
    survey.focusFirstQuestionAutomatic = false;

    survey.onComplete.add(this.alertResults);

    return {
      survey,
    };
  },
  methods: {
    alertResults(sender) {
      const results = JSON.stringify(sender.data);
      alert(results);
    },
  },
};
</script>
