<template>
  <div class="container">
    <h1>SurveyJS Library / Runner</h1>
    <Survey :survey="survey" />

         
  </div>
</template>

<script>
import { Survey, Model, StylesManager } from "survey-vue";
import "survey-vue/defaultV2.css";
StylesManager.applyTheme("defaultV2");
import { json } from "../data/survey_json";


import {  setLibraryContract, getTronWeb, test } from "../plugins/utils"
import { sampleTx } from "../plugins/walletConnect"



export default {
  components: {
    Survey
  },
  
  data() {
    const model = new Model(json);
    model.onComplete.add(this.surveyComplete);
    return {
      survey: model
    };
  },
  methods: {
    surveyComplete () {

     getTronWeb();
    
    // Wait a while to ensure tronweb object has already injected
    setTimeout(async ()=>{
        // init contract object
        await setLibraryContract();
        
        console.log("Begin to obtain the books information");
        // fetch all books
        // const books = await fetchAllBooks();
           
         await test(1);
        // this.posts = books;
        // console.log("The total number of Books: "+ books.length);
        
    },50);
      
    },
    async sendTx() {
      await sampleTx()
    },
  },
};
</script>