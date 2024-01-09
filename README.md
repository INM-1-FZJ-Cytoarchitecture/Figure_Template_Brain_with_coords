# Cloning and Running the 'Figure_Template_Brain_with_coords' Git Repository in MATLAB

## Prerequisites to install/clone the Repository
- MATLAB (preferably the latest version)
- Git installed and configured on your computer
- Access to the GitHub repository: 'Figure_Template_Brain_with_coords'

## Steps

### Cloning the Repository
1. **Cloning via Git**
    - Open a terminal (Cmd on Windows, Terminal on macOS/Linux).
    - Navigate to the directory where you want to clone the repository.
    - Execute the following command:
      ```
      git clone https://github.com/INM-1-FZJ-Cytoarchitecture/Figure_Template_Brain_with_coords
      ```
    - Wait until the cloning process is complete.

2. **Cloning via MATLAB Source Control**
    - Open MATLAB.
    - Go to **HOME** > **New** > **Script**.
    - In the editor, go to **TOOLS** > **Source Control** > **Manage Files**.
    - Select **Git** as source control.
    - Enter the URL: `https://github.com/INM-1-FZJ-Cytoarchitecture/Figure_Template_Brain_with_coords` and choose the desired path for cloning.
    - Click on **Retrieve**.

### Switching to the Cloned Folder
- After successful cloning, switch to the cloned directory in the terminal or MATLAB:
  ```
  cd path_to/Figure_Template_Brain_with_coords
  ```

### Running the Script
- Inside the 'Figure_Template_Brain_with_coords' directory, start the main script (e.g., `plot_maps_and_coordinates.m`) by entering the following command in MATLAB:
  ```
  plot_maps_and_coordinates
  ```
- Ensure that all required dependencies or data specified in the repository's documentation are present to successfully execute the script.


# MATLAB Script plot coordinates as spheres within MNI152 template

This documentation provides a detailed overview of the dependencies, functions, and execution steps of the MATLAB script for visualizing brain maps.

## Table of Contents
1. [Dependencies](#dependencies)
2. [Script Overview](#script-overview)
3. [Functions and Their Parameters](#functions-and-their-parameters)
4. [Execution Steps](#execution-steps)

---

## Dependencies
### Required Files and Folders
- **Folder `input_data`** with subfolders:
  - `template_volume`: Contains the file `mni_icbm152_t1_tal_nlin_asym_09c.nii`.
  - `coordinate_files`: Must contain at least one .XLSX file.
  - `orig_volume_as_nifti`: Must contain at least one .nii file.
- **SPM12 Toolbox**: Must be installed in the MATLAB path.

---

## Script Overview
The script performs the following main functions:
1. **Checking dependencies** (`check_dependencies`).
2. **Visualizing the template** (`visualize_template`).
3. **Visualizing data from an Excel file** (`plot_excel_data_on_figure`).
4. **Visualizing isosurfaces** (`plot_isosurface` for various NIFTI files).


---

## Functions and Their Parameters
### 1. `check_dependencies()`
- **Output**: `isDependenciesMet` (logical) - Indicates whether all dependencies are met.

### 2. `visualize_template(z_level_section, x_level_section, iso_value, iso_cap, view_angle)`
- **Input parameters**: Default values for sectional planes (`z_level_section`, `x_level_section`), iso-values (`iso_value`, `iso_cap`), and viewing angle (`view_angle`).
- **Output**: `h_figure` (figure handle), `template` (NIFTI header), `template_vol` (volume data).

### 3. `plot_excel_data_on_figure(h_figure, template, excelFilename)`
- **Input parameters**: `h_figure` (figure handle), `template` (NIFTI header), `excelFilename` (filename).
- **Output**: `h_figure` (updated figure handle).

### 4. `plot_isosurface(h_figure, niftiFilename, displayName, isoValue, faceColor, edgeColor, faceAlpha)`
- **Input parameters**: `h_figure` (figure handle), `niftiFilename` (file path), `displayName` (for legend), iso-value (`isoValue`), color settings (`faceColor`, `edgeColor`), and transparency (`faceAlpha`).
- **Output**: `h_figure` (updated figure handle), `h_patch` (patch handle).

---

## Execution Steps
1. **Initialization**: Clear all variables, close all windows, and clear the Command Window.

---

## Additional Notes
- **Comments and notes** are integrated into the code to facilitate traceability.
- **No changes** should be made after the comment "*Do not change anything from here on!!!*".
