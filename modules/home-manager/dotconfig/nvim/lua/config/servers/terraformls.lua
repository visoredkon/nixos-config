return {
  init_options = {
    validation = {
      enableEnhancedValidation = true,
    },
    experimentalFeatures = {
      validateOnSave = true,
      prefillRequiredFields = true,
    },
    indexing = {
      ignoreDirectoryNames = {
        ".git",
        ".idea",
        ".vscode",
        "terraform.tfstate.d",
        ".terragrunt-cache",
      },
    },
    ignoreSingleFileWarning = false,
  },
}
