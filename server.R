library(shiny)
library(NLP)
noDict = c("no", "never", "little", "few", "nobody", "nothing",
           "none", "seldom", "hardly", "nor", "t", "not")
emoDict = read.table("E:/GitHub/text2emoji/emotionDict.txt", header = TRUE)
emoji = read.table("E:/GitHub/text2emoji/emoji.txt", header = TRUE, 
                     stringsAsFactors = FALSE, sep = "\t")
shinyServer(function(input, output){
  output$emoji_out = renderText({
    testText = input$text_in
    if (length(testText) == 0) {
      testText = "absurd"
    }
    testText = String(tolower(testText))
    print(testText)
    text_sp = wordpunct_tokenizer(testText)
    textArr = testText[text_sp]
    if(sum(textArr %in% noDict)%%2 == 0) {
      posWeight = c(0, 0, 0, 0, 0 , 0, 0, 0, 0, 0)
    } else {
      posWeight = c(0, 0, 0, 0, 0 , 1, -1, 0, 0, 0)
    }
    sigWeight = rep(0, 10)
    if ("?" %in% textArr) {
      sigWeight = sigWeight + c(0,0,0,0,0,0,0,0,1,0)
    } 
    if ("!" %in% textArr) {
      sigWeight = sigWeight + c(0,1, posWeight[7] == 0, rep(0,7))
    }
    if (sum(emoji$emotion %in% textArr) > 0) {
      baseWeight  = emoji[emoji$emotion %in% textArr, -c(1,2)]
      if (nrow(baseWeight) > 1) {
        baseWeight = colSums(baseWeight)
      } else {
        baseWeight = unlist(baseWeight[1,])
      }
    } else{
      baseWeight = rep(0, 10)
    }
    emoWeight = emoDict[emoDict$word %in% textArr,]
    
    weighted = colSums(emoWeight[,-1]) + posWeight + sigWeight + baseWeight
    print(weighted)
    weighted = ifelse(weighted > 0, 1, 0)
    subEmoji = emoji[(emoji$positive == weighted["positive"]) & (emoji$negative == weighted["negative"]),]
    if (nrow(subEmoji) == 0) {
      subEmoji = emoji
    }
    dupWeighted = rep(weighted, nrow(subEmoji))
    dupWeighted = matrix(dupWeighted, ncol = 10, nrow = nrow(subEmoji), byrow = TRUE)
    hammingDis = rowSums(dupWeighted != subEmoji[,-c(1,2)])
    finalEmoji = subEmoji$emoji[hammingDis == min(hammingDis)]
    sample(finalEmoji, 1)
  })
})