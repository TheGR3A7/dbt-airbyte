{{
  config(
    materialized='view'
  )
}}

select 
    "Outdoor_Drybulb_Temperature__C_"::numeric as temperature_c,
    "Outdoor_Relative_Humidity____"::numeric as humidity_pct,
    "Direct_Solar_Radiation__W_m2_"::numeric as direct_radiation_wm2,
    "Diffuse_Solar_Radiation__W_m2_"::numeric as diffuse_radiation_wm2,
    
    "6h_Prediction_Outdoor_Drybulb_Temperature__C_"::numeric as temp_prediction_6h_c,
    "12h_Prediction_Outdoor_Drybulb_Temperature__C_"::numeric as temp_prediction_12h_c,
    "24h_Prediction_Outdoor_Drybulb_Temperature__C_"::numeric as temp_prediction_24h_c,
    
    "6h_Prediction_Outdoor_Relative_Humidity____"::numeric as humidity_prediction_6h_pct,
    "12h_Prediction_Outdoor_Relative_Humidity____"::numeric as humidity_prediction_12h_pct,
    "24h_Prediction_Outdoor_Relative_Humidity____"::numeric as humidity_prediction_24h_pct,
    
    "6h_Prediction_Diffuse_Solar_Radiation__W_m2_"::numeric as diffuse_rad_prediction_6h_wm2,
    "12h_Prediction_Diffuse_Solar_Radiation__W_m2_"::numeric as diffuse_rad_prediction_12h_wm2,
    "24h_Prediction_Diffuse_Solar_Radiation__W_m2_"::numeric as diffuse_rad_prediction_24h_wm2,
    
    "6h_Prediction_Direct_Solar_Radiation__W_m2_"::numeric as direct_rad_prediction_6h_wm2,
    "12h_Prediction_Direct_Solar_Radiation__W_m2_"::numeric as direct_rad_prediction_12h_wm2,
    "24h_Prediction_Direct_Solar_Radiation__W_m2_"::numeric as direct_rad_prediction_24h_wm2,
    
    _airbyte_raw_id,
    _airbyte_extracted_at as loaded_at,
    
    case 
        when "Outdoor_Drybulb_Temperature__C_"::numeric < 0 then 'freezing'
        when "Outdoor_Drybulb_Temperature__C_"::numeric < 10 then 'cold'
        when "Outdoor_Drybulb_Temperature__C_"::numeric < 20 then 'norm'
        when "Outdoor_Drybulb_Temperature__C_"::numeric < 30 then 'warm'
        else 'hot'
    end as temperature_category,
    
    case 
        when "Outdoor_Relative_Humidity____"::numeric < 30 then 'dry'
        when "Outdoor_Relative_Humidity____"::numeric < 60 then 'comfortable'
        else 'humid'
    end as humidity_category,
    
    "6h_Prediction_Outdoor_Drybulb_Temperature__C_"::numeric - "Outdoor_Drybulb_Temperature__C_"::numeric as temp_change_6h_c,
    "12h_Prediction_Outdoor_Drybulb_Temperature__C_"::numeric - "Outdoor_Drybulb_Temperature__C_"::numeric as temp_change_12h_c,
    "24h_Prediction_Outdoor_Drybulb_Temperature__C_"::numeric - "Outdoor_Drybulb_Temperature__C_"::numeric as temp_change_24h_c,
    
    "Direct_Solar_Radiation__W_m2_"::numeric + "Diffuse_Solar_Radiation__W_m2_"::numeric as total_radiation_wm2
from {{ source('airbyte_raw', 'src_csv_weather') }}