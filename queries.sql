## getLanguages

SELECT
	languageCode AS CODE,
	languageName AS `name` 
FROM
	getLanguages 
WHERE
	lang = '$lang'

## getMakes

SELECT
	all_makes.logoName,
	all_makes.ma_name,
	all_makes.id AS make_id 
FROM
	all_makes 
WHERE
	all_makes.ma_used = 1 
ORDER BY
	all_makes.ma_name ASC

## getModels($make_id)

SELECT DISTINCT
	all_models.id AS model_id,
	all_models.mo_name,
	all_models.mo_years_build,
	all_models.mo_make_id,
	all_models.modelPictureMimeDataName,
	all_makes.ma_name,
	all_makes.id AS make_id 
FROM
	all_models
	INNER JOIN all_makes ON all_models.mo_make_id = all_makes.make_id 
	AND all_models.mo_used = 1 
WHERE
	all_makes.id = $make_id 
ORDER BY
	all_models.mo_name ASC,
	all_models.mo_years_build ASC,
	all_models.mo_sort_order ASC
  
  ## getModifications($make_id,$model_id)
  
  SELECT
	rtStat.type_id,
	rtStat.repairtimeTypeId,
	rtStat.typeCategory,
	all_models.id AS ty_model_id,
	concat_ws( '-', all_types.ty_start_year, CASE WHEN all_types.ty_end_year IS NULL THEN '2022' ELSE all_types.ty_end_year END ) AS years,
	all_types.ty_end_year,
	all_types.ty_engine_code,
	all_types.ty_name,
	all_types.ty_power,
	all_types.ty_start_year,
	all_models.mo_name,
	all_models.mo_make_id,
	all_makes.id AS make_id,
	all_makes.ma_name 
FROM
	all_types
	INNER JOIN all_models ON all_types.ty_model_id = all_models.model_id
	INNER JOIN all_makes ON all_models.mo_make_id = all_makes.make_id
	LEFT JOIN rtStat ON rtStat.type_id = all_types.type_id 
WHERE
	all_types.ty_used = 1 
	AND all_models.mo_used = 1 
	AND all_makes.ma_used = 1 
	AND all_makes.id = $make_id 
	AND all_models.id = $model_id 
ORDER BY
	years
  
  ## getAdjustments($type_id,$lang)
  
  SELECT
	getAdjustments.category,
	getAdjustments.root_category,
	getAdjustments.type_id,
	getAdjustments.`language`,
	getAdjustments.`name`,
	getAdjustments.`order`,
	getAdjustments.unit,
	getAdjustments.`value`,
	getAdjustments.imageName,
	getAdjustments.remark 
FROM
	getAdjustments 
WHERE
	getAdjustments.type_id = $type_id 
	AND getAdjustments.`language` = '$lang'
  
  ## getlubricants($type_id,$lang)
  
  SELECT
	getAdjustments.lubricant_CategoryName,
	getAdjustments.lubricant_name,
	getAdjustments.lubricant_quality,
	getAdjustments.lubricant_temperature,
	getAdjustments.lubricant_viscosity,
	getAdjustments.`language`,
	getAdjustments.lubricant_order 
FROM
	getLubricants AS getAdjustments 
WHERE
	getAdjustments.type_id = $type_id 
	AND getAdjustments.`language` = '$lang' 
ORDER BY
	getAdjustments.lubricant_CategoryName,
	getAdjustments.lubricant_order
  
  ## getLubricantCapacities($type_id,$lang)
  
SELECT DISTINCT
	getLubricantCapacities.subAdjustments_category,
	getLubricantCapacities.subAdjustments_name,
	getLubricantCapacities.subAdjustments_remark,
	getLubricantCapacities.subAdjustments_value,
	getLubricantCapacities.subAdjustments_unit,
	getLubricantCapacities.subAdjustments_order,
	getLubricantCapacities.subAdjustments_imageName AS imageName 
FROM
	getLubricantCapacities 
WHERE
	getLubricantCapacities.type_id = $type_id 
	AND getLubricantCapacities.`language` = '$lang' 
ORDER BY
	getLubricantCapacities.subAdjustments_category,
	getLubricantCapacities.subAdjustments_order
  
  ## getDrawings($type_id,$lang)
	
SELECT
	getDrawings.description,
	getDrawings.root_description,
	getDrawings.mimeDataName,
	getDrawings.mimeDataName AS imageName,
	getDrawings.`order` 
FROM
	getDrawings 
WHERE
	getDrawings.type_id = $type_id 
	AND getDrawings.`language` = '$lang' 
ORDER BY
	getDrawings.root_description,
	getDrawings.`order` ASC
  
  ## getEngineLocations($type_id,$lang)
	
SELECT
	* 
FROM
	getEngineLocations 
WHERE
	getEngineLocations.carTypeId = $type_id 
	AND getEngineLocations.lang = '$lang' 
ORDER BY
	getEngineLocations.ORDER
  
  ## getEobdLocations($type_id,$lang)
	
SELECT
	getEobdLocations.location,
	getEobdLocations.mimeDataName,
	getEobdLocations.`order` 
FROM
	getEobdLocations 
WHERE
	getEobdLocations.carTypeId = $type_id 
	AND getEobdLocations.lang = '$lang'
  
  ## getFuseLocations($type_id,$lang)
	
SELECT
	getFuseLocations.item_value,
	getFuseLocations.item_type,
	getFuseLocations.item_location,
	getFuseLocations.item_description,
	getFuseLocations.systemLocationMimeDataName,
	getFuseLocations.`order`,
	getFuseLocations.side,
	getFuseLocations.itemsLocationMimeDataName,
	getFuseLocations.description 
FROM
	getFuseLocations 
WHERE
	getFuseLocations.carTypeId = $type_id 
	AND getFuseLocations.lang = '$lang'
  
##   getMaintenanceStories($type_id,$lang)
	
SELECT DISTINCT
	getMaintenanceStories.`name`,
	getMaintenanceStories.storyId 
FROM
	getMaintenanceStories 
WHERE
	getMaintenanceStories.carTypeId = $type_id 
	AND getMaintenanceStories.lang = '$lang' 
ORDER BY
	getMaintenanceStories.`order`
  
##   getStoryInfoDescription($story_id,$lang)
	
SELECT
	getStoryInfo.`name` AS storyName,
	IFNULL( getStoryInfoDescription.`name`, '<hr size=1>' ) AS storyText 
FROM
	getStoryInfo
	INNER JOIN getStoryInfoDescription ON getStoryInfo.story_id = getStoryInfoDescription.story_id 
	AND getStoryInfo.lang = getStoryInfoDescription.lang 
WHERE
	getStoryInfo.story_id = $story_id 
	AND getStoryInfo.lang = '$lang' 
ORDER BY
	getStoryInfo.`order` ASC
  
  ## getStoryInfo($story_id,$lang)
	
SELECT DISTINCT
	IFNULL( getStoryInfoDescription.`name`, '<hr size=1>' ) AS storyText,
	getStoryInfo.`name` storyPartTitle 
FROM
	getStoryInfoDescription
	INNER JOIN getStoryInfo ON getStoryInfoDescription.story_id = getStoryInfo.story_id 
	AND getStoryInfoDescription.lang = getStoryInfo.lang 
WHERE
	getStoryInfoDescription.story_id = $story_id 
	AND getStoryInfoDescription.lang = '$lang'

## getStoryOverview($story_id,$lang)

SELECT DISTINCT
	IFNULL( getStoryInfoDescription.`name`, '<hr size=1>' ) AS storyText 
FROM
	getStoryInfoDescription 
WHERE
	getStoryInfoDescription.story_id = $story_id 
	AND getStoryInfoDescription.lang = '$lang' 
ORDER BY
	getStoryInfoDescription.`order` ASC

## getWarningLights($type_id,$lang)

SELECT DISTINCT
	getStoryInfoDescription.mimeDataName,
	getStoryInfoDescription.`name` 
FROM
	getWarningLights
	INNER JOIN getStoryInfoDescription ON getWarningLights.story_id = getStoryInfoDescription.story_id 
WHERE
	getWarningLights.type_id = $type_id 
	AND getStoryInfoDescription.lang = '$lang'

## getRepairTimesTree($repairtimeTypeId,$lang,$typeCategory='QUICKGUIDES')

SELECT DISTINCT
	getFullTreeDistinct.root_node_id,
	getRepairtimeTopNodeNames.description,
	IFNULL( getSubNodeName ( getFullTreeDistinct.node_id, '$lang' ), getRepairtimeTopNodeNames.description ) AS top,
	getRepairtimeTopNodeNames.typeCategory,
	getFullTreeDistinct.node_id 
FROM
	getFullTreeDistinct
	INNER JOIN getRepairtimeTopNodeNames ON getFullTreeDistinct.root_node_id = getRepairtimeTopNodeNames.awNumber 
WHERE
	getFullTreeDistinct.repairtimeTypeId = $repairtimeTypeId 
	AND getRepairtimeTopNodeNames.lang = '$lang' 
	AND getRepairtimeTopNodeNames.typeCategory = '$typeCategory' 
ORDER BY
	getFullTreeDistinct.node_id + 0 ASC,
	getFullTreeDistinct.root_node_id + 0 ASC
  
  ## getrepairtimeTypeId($type_id)
	
SELECT
	repairtimeTypeId,
	typeCategory 
FROM
	getRepairtimeTypes2 
WHERE
	`type_id` = $type_id 
	AND repairtimeTypeId <> '' 
	LIMIT 1
  
  ## getRepairTimesSubnodeName($nodeId,$lang)
	
SELECT
	getRepairtimeSubnodeNames.Subnode_description AS nodeName 
FROM
	getRepairtimeSubnodeNames 
WHERE
	getRepairtimeSubnodeNames.Subnodes_id = '$nodeId' 
	AND getRepairtimeSubnodeNames.lang = '$lang'
