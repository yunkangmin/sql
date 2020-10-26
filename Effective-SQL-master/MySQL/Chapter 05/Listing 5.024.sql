-- Ensure you've run RecipesStructure.sql
-- and RecipesData.sql in the Sample Databases folder
-- in order to run this example. 

USE RecipesSample;

SELECT Recipes.RecipeTitle, 
  COUNT(Recipe_Ingredients.RecipeID) AS IngredCount
FROM (((Recipe_Classes 
  INNER JOIN Recipes
    ON Recipe_Classes.RecipeClassID = Recipes.RecipeClassID) 
  INNER JOIN Recipe_Ingredients
    ON Recipes.RecipeID = Recipe_Ingredients.RecipeID)
  INNER JOIN Ingredients
    ON Recipe_Ingredients.IngredientID = 
    Ingredients.IngredientID)
  INNER JOIN Ingredient_Classes 
    ON Ingredients.IngredientClassID = 
    Ingredient_Classes.IngredientClassID
WHERE Recipe_Classes.RecipeClassDescription = 'Main Course' 
  AND Ingredient_Classes.IngredientClassDescription = 'Spice'
GROUP BY Recipes.RecipeTitle
HAVING COUNT(Recipe_Ingredients.RecipeID) < 3;
