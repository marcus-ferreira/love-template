# Love2D Template

## Description
This is a basic template to start new projects with [Love2D](https://love2d.org/), a framework for game development in Lua. It provides an organized structure for code, assets, and libraries, making 2D game development faster and easier.

## How to Use
1. **Clone or use as template**: Clone this repository or use it as a template on GitHub to create a new project.
2. **Rename the project**: Update the repository name and modify files like `conf.lua` to match your game title.
3. **Install Love2D**: Make sure Love2D is installed on your system. Download it from [love2d.org](https://love2d.org/).
4. **Run the project**: Open a terminal in the project folder and run `love .`.
5. **Develop**: Add your assets in `assets/`, game entities in `src/entities/`, and use utility libraries from `src/libs/`.

## Project Structure
```
love-template/
├── conf.lua              # Love2D configuration (title, version, etc.)
├── main.lua              # Main game entry point
├── dependencies.lua      # Dependency loader / library imports
├── README.md             # This file
├── assets/               # Game assets
│   ├── fonts/            # Fonts
│   ├── images/           # Images
│   └── sounds/           # Sounds and music
└── src/
    ├── entities/         # Game entities (player, enemies, objects)
    └── libs/
        ├── love/         # Love2D-specific helper libraries
        │   ├── animation.lua
        │   ├── camera.lua
        │   ├── collision.lua
        │   ├── color.lua
        │   ├── data.lua
        │   ├── physics.lua
        │   ├── state.lua
        │   ├── timer.lua
        │   └── vector.lua
        └── lua/          # General Lua utility libraries
            ├── math.lua
            ├── string.lua
            └── table.lua
```

## Included Libraries
This template includes useful libraries for game development:
- **animation.lua**: Animation management.
- **camera.lua**: Camera control.
- **collision.lua**: Collision detection.
- **color.lua**: Color manipulation.
- **data.lua**: Data storage and retrieval.
- **physics.lua**: Physics helpers.
- **state.lua**: Game state management.
- **timer.lua**: Timer utilities.
- **vector.lua**: 2D vector math.
- General Lua utilities in `src/libs/lua/`.

## Dependencies
- [Love2D](https://love2d.org/) (recommended version: 11.x or higher)

## Contribution
This template is ready for personal use, but contributions are welcome. To contribute:
1. Fork the repository.
2. Create a branch for your change (`git checkout -b my-improvement`).
3. Commit your changes (`git commit -am 'Add new feature'`).
4. Push to the branch (`git push origin my-improvement`).
5. Open a Pull Request.

## License
This project is licensed under the MIT License. See the LICENSE file for details.
