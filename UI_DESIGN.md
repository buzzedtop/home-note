# UI Design Documentation

## Home Note Interface

### Layout Overview

```
┌─────────────────────────────────────────────────────────────┐
│  Home Note                                              ⚙️   │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌──────────────────────────────────────────┐              │
│  │ Enter a note                              │              │
│  │                                           │              │
│  │ Type your note here...                    │              │
│  │                                           │              │
│  └──────────────────────────────────────────┘   [ Add ]    │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ ≡  Buy groceries and clean the house        ↑ ↓ 🗑  │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ ≡  Meeting notes from today's discussion    ↑ ↓ 🗑  │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ ≡  TODO: Finish the project report by Fri   ↑ ↓ 🗑  │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
│  (Drag and drop to reorder)                                │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## Component Details

### 1. App Bar
- **Title**: "Home Note" displayed in the app bar
- **Background**: Purple theme (Material Design deep purple)
- **Style**: Material 3 design with modern elevation

### 2. Input Section
Located at the top of the screen:

- **Text Field**:
  - Multi-line input (3 lines visible)
  - Border: Outlined style
  - Label: "Enter a note"
  - Hint: "Type your note here..."
  - Auto-expands as you type

- **Add Button**:
  - Elevated button style
  - Text: "Add"
  - Position: Right of text field
  - Action: Adds note to list below
  - Keyboard: Press Enter to submit

### 3. Notes List Section

Each note card displays:

#### Left Side:
- **Drag Handle Icon** (≡): Three horizontal lines
  - Always visible
  - Indicates item can be dragged
  - Touchable area for drag gesture

#### Center:
- **Note Content**: Text of the note
  - Wraps to multiple lines if needed
  - Readable font size
  - Left-aligned

#### Right Side (Action Buttons):
- **Up Arrow (↑)**:
  - Moves note up one position
  - Disabled (grayed out) for first item
  - Tooltip: "Move up"

- **Down Arrow (↓)**:
  - Moves note down one position
  - Disabled (grayed out) for last item
  - Tooltip: "Move down"

- **Delete Icon (🗑)**:
  - Red color for danger indication
  - Removes note from list
  - Tooltip: "Delete"
  - No confirmation dialog (immediate delete)

### 4. Empty State
When no notes exist:
- Centered message: "No notes yet. Add one above!"
- Gray text color
- Friendly and inviting

## Interaction Patterns

### Adding a Note
1. Type text in the input field
2. Click "Add" button OR press Enter
3. Note appears at bottom of list
4. Input field clears automatically
5. Note is saved to storage

### Reordering Notes

#### Method 1: Drag and Drop
1. Touch/click the drag handle (≡)
2. Hold and drag note up or down
3. Release to drop in new position
4. Other notes shift to make space
5. Order is saved automatically

#### Method 2: Arrow Buttons
1. Click up arrow to move note up
2. Click down arrow to move note down
3. Note swaps position with neighbor
4. Order is saved automatically

### Deleting a Note
1. Click the delete icon (🗑)
2. Note is removed immediately
3. List updates automatically
4. Change is saved to storage

## Visual Styling

### Colors
- **Primary**: Deep Purple (#673AB7)
- **Accent**: Material purple variants
- **Error/Delete**: Red for delete button
- **Background**: White/Light gray
- **Card**: White with subtle shadow

### Typography
- **App Title**: 20pt, medium weight
- **Note Content**: 16pt, regular weight
- **Hint Text**: 16pt, light gray
- **Button Text**: 14pt, medium weight

### Spacing
- Input section: 16px padding all around
- Cards: 16px horizontal, 8px vertical margin
- Card internal: 12px padding
- Button spacing: 8px between icons

### Elevation
- App Bar: Elevation 4
- Cards: Elevation 2
- Button: Elevation 2 (elevated style)

## Responsive Design

The interface adapts to different screen sizes:

### Mobile (< 600px)
- Full-width layout
- Stack input and button vertically on very small screens
- Scrollable list

### Tablet (600-900px)
- Centered content with margins
- Wider cards for better readability

### Desktop (> 900px)
- Maximum content width: 800px
- Centered on screen
- Mouse hover effects on buttons

## Accessibility

- **Keyboard Navigation**: Full support
- **Screen Readers**: Semantic labels on all interactive elements
- **Tooltips**: Descriptive tooltips on icon buttons
- **Color Contrast**: Meets WCAG AA standards
- **Touch Targets**: Minimum 48x48 dp for all buttons

## Data Persistence

- **Storage**: Automatic save on every change
- **Format**: JSON in shared_preferences
- **Persistence**: Survives app restarts
- **Sync**: Changes reflect immediately in UI

## Future Enhancements UI

Potential UI improvements:
1. Note categories with color coding
2. Search/filter functionality
3. Sort options (date, alphabetical)
4. Multi-select for batch operations
5. Undo/redo functionality
6. Dark mode support
7. Rich text editing
8. Note priorities (high, medium, low)
