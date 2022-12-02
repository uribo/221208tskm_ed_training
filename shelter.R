###############################
# 徳島県オープンデータポータルサイト
# https://opendata.pref.tokushima.lg.jp/dataset/487.html
# 緊急避難場所 (徳島県)
# 洪水_登録データ一覧_2022年10月26日.csv (CSV 121KB)
################################

# 1. パッケージの読み込み -----------------------------------------------------------
library(readr)
library(dplyr)
library(sf)
library(ggplot2)
library(mapview)



# 2. データの読み込み -------------------------------------------------------------
df_hinanjyo <- 
  read_csv(file = "https://opendata.pref.tokushima.lg.jp/dataset/487/resource/6553/%E6%B4%AA%E6%B0%B4_%E7%99%BB%E9%8C%B2%E3%83%87%E3%83%BC%E3%82%BF%E4%B8%80%E8%A6%A7_2022%E5%B9%B410%E6%9C%8826%E6%97%A5_15%E6%99%8214%E5%88%86.csv",
           locale = locale(encoding = "cp932"))
glimpse(df_hinanjyo)

df_hinanjyo <- 
  select(df_hinanjyo,
         `市町村`, `タイトル`, `所在地`, `緯度`, `経度`, `分類`)
glimpse(df_hinanjyo)

# 緯度 ... latitude
# 経度 ... longitude
colnames(df_hinanjyo) <- 
  c("city", "title", "address", "latitude", "longitude", "type")
head(df_hinanjyo)

# cityが欠損値
count(df_hinanjyo, city)
filter(df_hinanjyo, is.na(city))
filter(df_hinanjyo, !is.na(city))

df_hinanjyo$address[1]
df_hinanjyo$address

stringr::str_remove(df_hinanjyo$address[1], "徳島県")
stringr::str_extract(df_hinanjyo$address[1], ".{2}郡.{2,3}町")
x <- 
  which(is.na(stringr::str_extract(df_hinanjyo$address, "(.{2}郡.{2,3}町|.{2,3}(市|町|村))")))
df_hinanjyo$address[x]

df_hinanjyo <- 
  mutate(df_hinanjyo,
         city = stringr::str_extract(address, "(.{2}郡.{2,3}町|.{2,3}(市|町|村))"))

count(df_hinanjyo, city)
count(df_hinanjyo, city, sort = TRUE)

sf_hinanjyo <- 
  st_as_sf(df_hinanjyo,
           coords = c("longitude", "latitude"),
           crs = 4326)

mapview(sf_hinanjyo)
mapview(sf_hinanjyo, zcol = "city")
