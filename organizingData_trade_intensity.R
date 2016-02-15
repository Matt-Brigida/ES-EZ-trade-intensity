## This script will ready the convert the data into a structure useful to analyze trade intensity in ES futures (maybe add in options later -- commented for now)

library(data.table)

## data layout guide: http://www.cmegroup.com/confluence/display/EPICSANDBOX/Time+and+Sales+CSV+Layout

## October Futures ----

## create data.table
esOctDT <- fread('../CME_TICK_ES_201510.csv', stringsAsFactors = FALSE, header = FALSE, sep = ",")
## has 13015323 rows
names(esOctDT) <- c("tradeDate", "tradeTime", "tradeSeqNum_esOct", "sessionInd_esOct", "tickerSymb_esOct", "typeInd_esOct", "deliveryDate_esOct", "tradeQuantity_esOct", "strikePrice_esOct", "tradePrice_esOct", "askBidType_esOct", "indicativeQuoteType_esOct", "marketQuote_esOct", "closeOpenType_esOct", "validOpenException_esOct", "postClose_esOct", "cancelCodeType_esOct", "insertCodeType_esOct", "fastLateInd_esOct", "cabinetInd" , "bookInd_esOct", "entryDate_esOct", "exchangeCode_esOct")


setkey(esOctDT, tradeDate, tradeTime, deliveryDate_esOct)

esGroupedbySecond.quant <- esOctDT[, sum(tradeQuantity_esOct),  by = key(esOctDT)]
names(esGroupedbySecond.quant)[4] <- "sumTradeQuantity_esOct"

esGroupedbySecond.price <- esOctDT[, mean(tradePrice_esOct),  by = key(esOctDT)]
names(esGroupedbySecond.price)[4] <- "meanTradePrice_esOct"

## merge(esGroupedbySecond.quant, esGroupedbySecond.price)
octData <- esGroupedbySecond.quant[esGroupedbySecond.price]

rm('esOctDT')

## output csv to be read into analysis script ----
write.csv(x = octData, file = "octData.csv")
