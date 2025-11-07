#!/usr/bin/env python3
"""
Example Python script for processing notes
This demonstrates how Python can be integrated for future processing needs
"""

import json
import sys

def process_notes(notes_json):
    """
    Example processing function that could:
    - Analyze note content
    - Extract action items
    - Categorize notes
    - Perform NLP tasks
    """
    notes = json.loads(notes_json)
    
    processed_notes = []
    for note in notes:
        # Example: Add word count
        word_count = len(note['content'].split())
        
        # Example: Detect if it's an action item
        is_action = any(keyword in note['content'].lower() 
                       for keyword in ['todo', 'task', 'action', 'must', 'need to'])
        
        processed_note = {
            **note,
            'word_count': word_count,
            'is_action': is_action,
            'processed': True
        }
        processed_notes.append(processed_note)
    
    return processed_notes

def main():
    # Example usage
    example_notes = json.dumps([
        {"id": "1", "content": "Buy groceries and clean the house"},
        {"id": "2", "content": "Meeting notes from today's discussion"},
        {"id": "3", "content": "TODO: Finish the project report by Friday"}
    ])
    
    print("Example Python Processing for Home Note")
    print("=" * 50)
    print("\nOriginal notes:")
    print(json.dumps(json.loads(example_notes), indent=2))
    
    processed = process_notes(example_notes)
    
    print("\nProcessed notes:")
    print(json.dumps(processed, indent=2))
    
    print("\nThis demonstrates how Python can enhance notes with:")
    print("- Word counting")
    print("- Action item detection")
    print("- Content analysis")
    print("- And much more...")

if __name__ == "__main__":
    main()
