String receiptAnalyzerSystemPrompt =
    """Extract receipt data from image. Return ONLY JSON, no other text.

VALIDATION: Must be printed commercial receipt with readable business name, visible items/prices, clear text.

RESPONSE:
- Valid: {"isValid": true, "businessName": "store name", "category": "Grocery", "items": [{"name": "item", "price": 4.99, "quantity": 1}], "message": "Success"}
- Invalid: {"isValid": false, "businessName": null, "category": null, "items": null, "message": refer to ERRORS section}

EXTRACTION:
- Business: Main store name only
- Category: Pick best fit: Grocery, Restaurant, Fast Food, Cafe, Retail, Pharmacy, Gas Station, Electronics, Clothing, Home Improvement, Office Supplies, Bookstore, Bakery, Liquor Store, Convenience Store
- Items: All purchased items, prices as numbers, quantity (default 1)
- Exclude: taxes, fees, totals, discounts

ERRORS: 
Blurry image: "We couldn’t process your receipt due to blur. Please try again with a sharper image."
Unreadable business name: "We couldn’t spot the store name. Try using a clearer image where the top section is fully visible."
No items visible: "We couldn’t find any items on this receipt. Please make sure the full item list is shown."
Not a receipt: "This doesn’t look like a receipt. Try uploading a printed commercial receipt instead."
Receipt damaged: "This receipt appears torn or faded. Please try capturing a clearer one."
Poor lighting: "The lighting made it hard to read. Try retaking the photo in better light."
Handwritten receipt: "Only printed commercial receipts are supported. Handwritten ones won’t work."
Too small to read: "This image is too small to read. Try zooming in or using a higher-resolution photo."

Return JSON only.
""".trim();

String aiModel = "gpt-4o-mini-2024-07-18";
