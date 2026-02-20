import Foundation

struct RecipeService {
    static func fetchRecipe(timeFilter: TimeFilter?, vibeFilter: VibeFilter?) -> Recipe {
        var candidates = Self.mockRecipes
        
        if let time = timeFilter {
            candidates = candidates.filter { $0.totalTime <= time.maxMinutes }
        }
        
        if let vibe = vibeFilter {
            candidates = candidates.filter { $0.vibes.contains(vibe.rawValue) }
        }
        
        if candidates.isEmpty {
            candidates = Self.mockRecipes
        }
        
        return candidates.randomElement() ?? Self.mockRecipes[0]
    }

    static let mockRecipes: [Recipe] = [
        Recipe(
            id: "1",
            title: "Sheet Pan Chicken Fajitas",
            imageURL: "https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=800&q=80",
            cookTime: 20,
            prepTime: 10,
            servings: 4,
            difficulty: "Easy",
            cuisineType: "Mexican",
            vibes: ["Lazy", "Comfort"],
            reason: "Minimal cleanup and you haven't had Mexican in a while — ready in 30 min.",
            ingredients: [
                Ingredient(id: "1a", name: "chicken breast", amount: "1.5", unit: "lbs"),
                Ingredient(id: "1b", name: "bell peppers", amount: "3", unit: ""),
                Ingredient(id: "1c", name: "yellow onion", amount: "1", unit: "large"),
                Ingredient(id: "1d", name: "olive oil", amount: "2", unit: "tbsp"),
                Ingredient(id: "1e", name: "chili powder", amount: "1", unit: "tbsp"),
                Ingredient(id: "1f", name: "cumin", amount: "1", unit: "tsp"),
                Ingredient(id: "1g", name: "garlic powder", amount: "1", unit: "tsp"),
                Ingredient(id: "1h", name: "flour tortillas", amount: "8", unit: ""),
                Ingredient(id: "1i", name: "lime", amount: "1", unit: ""),
                Ingredient(id: "1j", name: "sour cream", amount: "1/2", unit: "cup")
            ],
            steps: [
                RecipeStep(id: 1, instruction: "Preheat oven to 425°F. Line a large sheet pan with parchment paper.", duration: nil),
                RecipeStep(id: 2, instruction: "Slice chicken into thin strips. Cut bell peppers and onion into strips.", duration: 5),
                RecipeStep(id: 3, instruction: "Toss everything with olive oil, chili powder, cumin, garlic powder, salt and pepper on the sheet pan.", duration: nil),
                RecipeStep(id: 4, instruction: "Spread in a single layer and bake for 20 minutes until chicken is cooked through.", duration: 20),
                RecipeStep(id: 5, instruction: "Warm tortillas, squeeze lime over the fajita mix, and serve with sour cream.", duration: nil)
            ],
            dietaryTags: ["Dairy-Free Option"]
        ),
        Recipe(
            id: "2",
            title: "Creamy Tomato Basil Soup",
            imageURL: "https://images.unsplash.com/photo-1547592166-23ac45744acd?w=800&q=80",
            cookTime: 25,
            prepTime: 5,
            servings: 4,
            difficulty: "Easy",
            cuisineType: "American",
            vibes: ["Comfort", "Lazy", "Healthy"],
            reason: "Perfect for a cozy night in — warm, creamy, and ready before you know it.",
            ingredients: [
                Ingredient(id: "2a", name: "canned crushed tomatoes", amount: "2", unit: "cans"),
                Ingredient(id: "2b", name: "vegetable broth", amount: "2", unit: "cups"),
                Ingredient(id: "2c", name: "heavy cream", amount: "1/2", unit: "cup"),
                Ingredient(id: "2d", name: "fresh basil", amount: "1/4", unit: "cup"),
                Ingredient(id: "2e", name: "garlic cloves", amount: "3", unit: ""),
                Ingredient(id: "2f", name: "butter", amount: "2", unit: "tbsp"),
                Ingredient(id: "2g", name: "sugar", amount: "1", unit: "tsp"),
                Ingredient(id: "2h", name: "crusty bread", amount: "1", unit: "loaf")
            ],
            steps: [
                RecipeStep(id: 1, instruction: "Melt butter in a large pot over medium heat. Sauté minced garlic for 1 minute.", duration: 2),
                RecipeStep(id: 2, instruction: "Add crushed tomatoes, broth, and sugar. Bring to a simmer.", duration: 5),
                RecipeStep(id: 3, instruction: "Simmer for 15 minutes, stirring occasionally.", duration: 15),
                RecipeStep(id: 4, instruction: "Blend until smooth with an immersion blender. Stir in cream and torn basil.", duration: nil),
                RecipeStep(id: 5, instruction: "Season with salt and pepper. Serve with crusty bread.", duration: nil)
            ],
            dietaryTags: ["Vegetarian"]
        ),
        Recipe(
            id: "3",
            title: "Honey Garlic Salmon",
            imageURL: "https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=800&q=80",
            cookTime: 12,
            prepTime: 5,
            servings: 2,
            difficulty: "Easy",
            cuisineType: "Asian-Fusion",
            vibes: ["Healthy", "Fancy"],
            reason: "Impressive enough for date night but only 17 minutes start to finish.",
            ingredients: [
                Ingredient(id: "3a", name: "salmon fillets", amount: "2", unit: "6oz"),
                Ingredient(id: "3b", name: "honey", amount: "3", unit: "tbsp"),
                Ingredient(id: "3c", name: "soy sauce", amount: "2", unit: "tbsp"),
                Ingredient(id: "3d", name: "garlic cloves", amount: "4", unit: "minced"),
                Ingredient(id: "3e", name: "rice vinegar", amount: "1", unit: "tbsp"),
                Ingredient(id: "3f", name: "sesame oil", amount: "1", unit: "tsp"),
                Ingredient(id: "3g", name: "jasmine rice", amount: "1", unit: "cup"),
                Ingredient(id: "3h", name: "steamed broccoli", amount: "2", unit: "cups")
            ],
            steps: [
                RecipeStep(id: 1, instruction: "Mix honey, soy sauce, garlic, rice vinegar, and sesame oil in a small bowl.", duration: nil),
                RecipeStep(id: 2, instruction: "Heat an oven-safe skillet over medium-high heat with a drizzle of oil.", duration: nil),
                RecipeStep(id: 3, instruction: "Sear salmon skin-side up for 3 minutes until golden.", duration: 3),
                RecipeStep(id: 4, instruction: "Flip salmon, pour the honey garlic sauce over it, and transfer to a 400°F oven.", duration: nil),
                RecipeStep(id: 5, instruction: "Bake for 8-10 minutes until salmon flakes easily. Serve over rice with broccoli.", duration: 9)
            ],
            dietaryTags: ["Gluten-Free Option"]
        ),
        Recipe(
            id: "4",
            title: "Spicy Thai Basil Chicken",
            imageURL: "https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?w=800&q=80",
            cookTime: 10,
            prepTime: 10,
            servings: 4,
            difficulty: "Easy",
            cuisineType: "Thai",
            vibes: ["Spicy", "Adventurous"],
            reason: "Big bold flavors with almost no effort — the kind of meal that makes you feel like a pro.",
            ingredients: [
                Ingredient(id: "4a", name: "ground chicken", amount: "1", unit: "lb"),
                Ingredient(id: "4b", name: "Thai basil leaves", amount: "1", unit: "cup"),
                Ingredient(id: "4c", name: "Thai chilies", amount: "3", unit: ""),
                Ingredient(id: "4d", name: "garlic cloves", amount: "5", unit: "minced"),
                Ingredient(id: "4e", name: "soy sauce", amount: "2", unit: "tbsp"),
                Ingredient(id: "4f", name: "oyster sauce", amount: "1", unit: "tbsp"),
                Ingredient(id: "4g", name: "fish sauce", amount: "1", unit: "tbsp"),
                Ingredient(id: "4h", name: "sugar", amount: "1", unit: "tsp"),
                Ingredient(id: "4i", name: "jasmine rice", amount: "2", unit: "cups"),
                Ingredient(id: "4j", name: "fried egg", amount: "4", unit: "")
            ],
            steps: [
                RecipeStep(id: 1, instruction: "Cook jasmine rice according to package directions.", duration: nil),
                RecipeStep(id: 2, instruction: "Heat oil in a wok over high heat. Add garlic and chilies, stir for 30 seconds.", duration: 1),
                RecipeStep(id: 3, instruction: "Add ground chicken, breaking it apart. Cook until no longer pink.", duration: 5),
                RecipeStep(id: 4, instruction: "Add soy sauce, oyster sauce, fish sauce, and sugar. Toss to combine.", duration: nil),
                RecipeStep(id: 5, instruction: "Remove from heat and fold in Thai basil until wilted. Serve over rice with a fried egg.", duration: nil)
            ],
            dietaryTags: ["Dairy-Free"]
        ),
        Recipe(
            id: "5",
            title: "One-Pot Creamy Tuscan Pasta",
            imageURL: "https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=800&q=80",
            cookTime: 20,
            prepTime: 5,
            servings: 4,
            difficulty: "Easy",
            cuisineType: "Italian",
            vibes: ["Comfort", "Lazy"],
            reason: "One pot, zero stress — creamy pasta that practically makes itself.",
            ingredients: [
                Ingredient(id: "5a", name: "penne pasta", amount: "1", unit: "lb"),
                Ingredient(id: "5b", name: "sun-dried tomatoes", amount: "1/2", unit: "cup"),
                Ingredient(id: "5c", name: "baby spinach", amount: "3", unit: "cups"),
                Ingredient(id: "5d", name: "heavy cream", amount: "1", unit: "cup"),
                Ingredient(id: "5e", name: "chicken broth", amount: "3", unit: "cups"),
                Ingredient(id: "5f", name: "parmesan cheese", amount: "1/2", unit: "cup"),
                Ingredient(id: "5g", name: "garlic cloves", amount: "3", unit: "minced"),
                Ingredient(id: "5h", name: "Italian seasoning", amount: "1", unit: "tsp")
            ],
            steps: [
                RecipeStep(id: 1, instruction: "In a large pot, sauté garlic in olive oil for 1 minute over medium heat.", duration: 1),
                RecipeStep(id: 2, instruction: "Add broth, cream, sun-dried tomatoes, Italian seasoning, and pasta.", duration: nil),
                RecipeStep(id: 3, instruction: "Bring to a boil, then reduce heat. Simmer covered for 12-14 minutes, stirring occasionally.", duration: 14),
                RecipeStep(id: 4, instruction: "Stir in spinach until wilted, then add parmesan.", duration: nil),
                RecipeStep(id: 5, instruction: "Season with salt and pepper. Let rest 2 minutes to thicken before serving.", duration: 2)
            ],
            dietaryTags: ["Vegetarian"]
        ),
        Recipe(
            id: "6",
            title: "Korean Beef Bulgogi Bowls",
            imageURL: "https://images.unsplash.com/photo-1590301157890-4810ed352733?w=800&q=80",
            cookTime: 15,
            prepTime: 10,
            servings: 4,
            difficulty: "Medium",
            cuisineType: "Korean",
            vibes: ["Adventurous", "Spicy"],
            reason: "Sweet, savory, a little smoky — this bowl is a crowd favorite for good reason.",
            ingredients: [
                Ingredient(id: "6a", name: "ribeye or sirloin", amount: "1.5", unit: "lbs"),
                Ingredient(id: "6b", name: "soy sauce", amount: "1/4", unit: "cup"),
                Ingredient(id: "6c", name: "brown sugar", amount: "2", unit: "tbsp"),
                Ingredient(id: "6d", name: "sesame oil", amount: "1", unit: "tbsp"),
                Ingredient(id: "6e", name: "garlic cloves", amount: "4", unit: "minced"),
                Ingredient(id: "6f", name: "ginger", amount: "1", unit: "tsp"),
                Ingredient(id: "6g", name: "gochujang", amount: "1", unit: "tbsp"),
                Ingredient(id: "6h", name: "rice", amount: "2", unit: "cups"),
                Ingredient(id: "6i", name: "green onions", amount: "4", unit: ""),
                Ingredient(id: "6j", name: "sesame seeds", amount: "1", unit: "tbsp")
            ],
            steps: [
                RecipeStep(id: 1, instruction: "Slice beef very thin against the grain. Mix soy sauce, brown sugar, sesame oil, garlic, ginger, and gochujang.", duration: nil),
                RecipeStep(id: 2, instruction: "Marinate beef in the sauce for at least 10 minutes (or up to overnight).", duration: 10),
                RecipeStep(id: 3, instruction: "Cook rice according to package directions.", duration: nil),
                RecipeStep(id: 4, instruction: "Heat a large skillet over high heat. Cook beef in batches for 2-3 minutes per side.", duration: 6),
                RecipeStep(id: 5, instruction: "Serve over rice, garnished with sliced green onions and sesame seeds.", duration: nil)
            ],
            dietaryTags: ["Dairy-Free"]
        ),
        Recipe(
            id: "7",
            title: "Mediterranean Chickpea Bowls",
            imageURL: "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800&q=80",
            cookTime: 10,
            prepTime: 10,
            servings: 2,
            difficulty: "Easy",
            cuisineType: "Mediterranean",
            vibes: ["Healthy", "Lazy"],
            reason: "Fresh, filling, and barely any cooking required. Your future self will thank you.",
            ingredients: [
                Ingredient(id: "7a", name: "canned chickpeas", amount: "1", unit: "can"),
                Ingredient(id: "7b", name: "cucumber", amount: "1", unit: ""),
                Ingredient(id: "7c", name: "cherry tomatoes", amount: "1", unit: "cup"),
                Ingredient(id: "7d", name: "red onion", amount: "1/4", unit: ""),
                Ingredient(id: "7e", name: "feta cheese", amount: "1/2", unit: "cup"),
                Ingredient(id: "7f", name: "hummus", amount: "1/2", unit: "cup"),
                Ingredient(id: "7g", name: "olive oil", amount: "2", unit: "tbsp"),
                Ingredient(id: "7h", name: "lemon", amount: "1", unit: ""),
                Ingredient(id: "7i", name: "pita bread", amount: "2", unit: "")
            ],
            steps: [
                RecipeStep(id: 1, instruction: "Drain and rinse chickpeas. Toss with olive oil, salt, pepper, and a squeeze of lemon.", duration: nil),
                RecipeStep(id: 2, instruction: "Dice cucumber, halve tomatoes, and thinly slice red onion.", duration: 5),
                RecipeStep(id: 3, instruction: "Warm pita bread in a dry skillet for 1 minute per side.", duration: 2),
                RecipeStep(id: 4, instruction: "Build bowls: hummus on the bottom, chickpeas and veggies on top, crumbled feta over everything.", duration: nil),
                RecipeStep(id: 5, instruction: "Drizzle with olive oil and lemon juice. Serve with warm pita.", duration: nil)
            ],
            dietaryTags: ["Vegetarian", "Gluten-Free Option"]
        ),
        Recipe(
            id: "8",
            title: "Beef Tenderloin with Herb Butter",
            imageURL: "https://images.unsplash.com/photo-1558030006-450675393462?w=800&q=80",
            cookTime: 45,
            prepTime: 15,
            servings: 4,
            difficulty: "Hard",
            cuisineType: "French",
            vibes: ["Fancy"],
            reason: "When you want to impress — restaurant-quality but completely doable at home.",
            ingredients: [
                Ingredient(id: "8a", name: "beef tenderloin", amount: "2", unit: "lbs"),
                Ingredient(id: "8b", name: "butter", amount: "4", unit: "tbsp"),
                Ingredient(id: "8c", name: "fresh rosemary", amount: "2", unit: "sprigs"),
                Ingredient(id: "8d", name: "fresh thyme", amount: "4", unit: "sprigs"),
                Ingredient(id: "8e", name: "garlic cloves", amount: "4", unit: ""),
                Ingredient(id: "8f", name: "Dijon mustard", amount: "2", unit: "tbsp"),
                Ingredient(id: "8g", name: "olive oil", amount: "2", unit: "tbsp"),
                Ingredient(id: "8h", name: "baby potatoes", amount: "1", unit: "lb"),
                Ingredient(id: "8i", name: "asparagus", amount: "1", unit: "bunch")
            ],
            steps: [
                RecipeStep(id: 1, instruction: "Remove tenderloin from fridge 30 minutes before cooking. Pat dry and season generously with salt and pepper.", duration: nil),
                RecipeStep(id: 2, instruction: "Preheat oven to 425°F. Mix softened butter with minced rosemary, thyme, and garlic.", duration: nil),
                RecipeStep(id: 3, instruction: "Sear tenderloin in a hot oven-safe skillet with olive oil, 2 minutes per side.", duration: 8),
                RecipeStep(id: 4, instruction: "Brush with Dijon mustard and top with herb butter. Roast for 25-30 minutes for medium-rare (135°F).", duration: 28),
                RecipeStep(id: 5, instruction: "Rest for 10 minutes before slicing. Serve with roasted potatoes and asparagus.", duration: 10)
            ],
            dietaryTags: ["Gluten-Free"]
        )
    ]
}
