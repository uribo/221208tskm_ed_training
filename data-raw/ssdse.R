library(ssdse) # https://github.com/uribo/ssdse
library(dplyr)


# SSDSEデータの読み込み -----------------------------------------------------------
df_ssdse_b <- 
  ssdse::read_ssdse_b("https://www.nstac.go.jp/sys/files/SSDSE-B-2022.csv",
                    lang = "ja")


# データの加工 ------------------------------------------------------------------
df_ssdse_b_tiny <- 
  df_ssdse_b |>
  select(`年度`, `都道府県`, `人口・世帯`, `自然環境`, `教育`, `家計`) |> 
  tidyr::unnest(cols = c(`人口・世帯`, `自然環境`, `教育`, `家計`)) |>
  select(`年度`, `都道府県`, 
         `総人口`, `総人口（男）`, `総人口（女）`, 
         `出生数`, `死亡数`,
         `年平均気温`, `降水量（年間）`,
         `幼稚園数`, `小学校数`, `中学校数`, `高等学校数`, `短期大学数`, `大学数`,
         `消費支出（二人以上の世帯）`, `教育費（二人以上の世帯）`) |> 
  mutate(`年度` = as.character(`年度`))

df_ssdse_b_tiny_shikoku <- 
  df_ssdse_b_tiny |> 
  # 四国４県に絞り込み
  filter(`都道府県` %in% c("徳島県", "香川県", "愛媛県", "高知県"))


# データの保存 ------------------------------------------------------------------
df_ssdse_b_tiny_shikoku |> 
  readr::write_rds(here::here("data-raw/ssdse_b_tiny_shikoku.rds"))
