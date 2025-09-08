-- Recipe Manager Database Setup


-- Create database
CREATE DATABASE IF NOT EXISTS recipe_manager;
USE recipe_manager;

-- Create recipes table
CREATE TABLE IF NOT EXISTS recipes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    ingredients TEXT NOT NULL,
    steps TEXT NOT NULL,
    category VARCHAR(100) NOT NULL,
    image VARCHAR(255),
    calories INT DEFAULT 0,
    is_favorite BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Insert sample data
INSERT INTO recipes (title, ingredients, steps, category, image, calories, is_favorite) VALUES 
(
    'Classic Spaghetti Carbonara',
    '400g spaghetti\n200g pancetta or bacon\n4 large eggs\n100g Pecorino Romano cheese\n2 cloves garlic\nBlack pepper\nSalt\nOlive oil',
    '1. Cook spaghetti in boiling salted water until al dente\n2. Meanwhile, heat olive oil in a large pan and cook pancetta until crispy\n3. Beat eggs with grated cheese and black pepper\n4. Drain pasta and add to the pan with pancetta\n5. Remove from heat and quickly mix in egg mixture\n6. Toss until creamy, adding pasta water if needed\n7. Serve immediately with extra cheese',
    'Main Course',
    'https://images.unsplash.com/photo-1612874742237-6526221588e3?w=800&h=600&fit=crop',
    750,
    TRUE
),
(
    'Chocolate Chip Cookies',
    '2¼ cups flour\n1 tsp baking soda\n1 tsp salt\n1 cup butter\n¾ cup granulated sugar\n¾ cup brown sugar\n2 eggs\n2 tsp vanilla\n2 cups chocolate chips',
    '1. Preheat oven to 375°F (190°C)\n2. Mix flour, baking soda, and salt\n3. Cream butter and sugars until fluffy\n4. Beat in eggs and vanilla\n5. Gradually add flour mixture\n6. Stir in chocolate chips\n7. Drop spoonfuls on baking sheet\n8. Bake 9-11 minutes until golden\n9. Cool on wire rack',
    'Dessert',
    'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=800&h=600&fit=crop',
    180,
    FALSE
),
(
    'Fresh Caesar Salad',
    'Romaine lettuce\nParmesan cheese\nCroutons\n2 cloves garlic\n2 anchovies\n1 egg yolk\nLemon juice\nOlive oil\nWorcestershire sauce\nDijon mustard\nBlack pepper',
    '1. Wash and chop romaine lettuce\n2. Make dressing: mash garlic and anchovies\n3. Whisk in egg yolk, lemon juice, and mustard\n4. Slowly drizzle in olive oil while whisking\n5. Add Worcestershire and pepper\n6. Toss lettuce with dressing\n7. Top with Parmesan and croutons\n8. Serve immediately',
    'Appetizer',
    'https://images.unsplash.com/photo-1551248429-40975aa4de74?w=800&h=600&fit=crop',
    320,
    TRUE
),
(
    'Grilled Chicken Breast',
    '4 chicken breasts\n2 tbsp olive oil\n1 tsp garlic powder\n1 tsp paprika\n1 tsp oregano\nSalt and pepper\nLemon juice',
    '1. Preheat grill to medium-high heat\n2. Mix olive oil with spices\n3. Coat chicken breasts with spice mixture\n4. Grill for 6-8 minutes per side\n5. Check internal temperature reaches 165°F\n6. Let rest for 5 minutes\n7. Serve with lemon juice',
    'Main Course',
    'https://images.unsplash.com/photo-1532636721573-f47cc8e5342a?w=800&h=600&fit=crop',
    285,
    FALSE
),
(
    'Fresh Fruit Smoothie',
    '1 banana\n1 cup strawberries\n1/2 cup blueberries\n1 cup almond milk\n1 tbsp honey\n1/2 cup ice cubes\n1 tsp vanilla extract',
    '1. Add all ingredients to blender\n2. Blend on high for 60 seconds\n3. Check consistency and add more milk if needed\n4. Blend again until smooth\n5. Taste and adjust sweetness\n6. Pour into glasses\n7. Serve immediately',
    'Beverage',
    'https://images.unsplash.com/photo-1553530666-ba11a7da3888?w=800&h=600&fit=crop',
    150,
    TRUE
),
(
    'Homemade Pizza Margherita',
     'Pizza dough\n1/2 cup tomato sauce\n200g fresh mozzarella\nFresh basil leaves\n2 tbsp olive oil\nSalt and pepper\nParmesan cheese',
    '1. Preheat oven to 475°F (245°C)\n2. Roll out pizza dough\n3. Spread tomato sauce evenly\n4. Add torn mozzarella pieces\n5. Drizzle with olive oil\n6. Bake for 12-15 minutes\n7. Add fresh basil after baking\n8. Slice and serve hot',
    'Main Course',
    'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=800&h=600&fit=crop',
    420,
    FALSE
);

-- Display success message
SELECT 'Database setup completed successfully!' as message;