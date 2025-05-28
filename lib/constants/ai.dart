String systemPrompt =
    """Extract receipt data from image. Return ONLY JSON, no other text.

VALIDATION: All required - printed commercial receipt, readable business name, visible items with prices, clear text quality.

RESPONSE:
- Valid: {"isValid": true, "businessName": "store name", "category": Category options, "items": [{"name": "item", "price": 4.99, "quantity": 1}], "message": "Success"}
- Invalid: {"isValid": false, "businessName": null, "category": null, "items": null, "message": refer to ERRORS section}

EXTRACTION:
- Business: Main store name only
- Category: Choose the MOST APPROPRIATE Category option below:
- Category options: Grocery, Restaurant, Fast Food, Cafe, Retail, Pharmacy, Gas Station, Electronics, Clothing, Home Improvement, Office Supplies, Bookstore, Bakery, Liquor Store, Convenience Store
- Items: Extract EVERY SINGLE purchased item from the receipt, unit prices as numbers, quantity (default 1)
- Exclude: taxes, fees, totals, discounts

ERRORS: "Image too blurry", "Business name unreadable", "No items visible", "Not a receipt", "Receipt damaged", "Poor lighting", "Handwritten receipt", "Receipt too small"

Return JSON only.
""";
