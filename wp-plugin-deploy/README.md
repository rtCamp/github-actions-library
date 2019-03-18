# GitHub action for WordPress.org Plugin Deployment

This actions uses the content in the latest pushed tag, runs the build process inside the repository root and copies latest files excluding specified files and commits to WP.org plugin directory.
If an assets directory is provide it will be used to update assets directory of the plugin at WP.org

## Configuration

### Required secrets
* `WORDPRESS_USERNAME`
* `WORDPRESS_PASSWORD`

### Optional environment variables
* `SLUG` - Defaults to the respository name, customizable in case your WordPress repository has a different slug
* `ASSETS_DIR` - If assets directory is provided then it's content will be used to update `assets` direct at plugin svn repository.
* `CUSTOM_COMMAND` - This can be used to pass custom command which can be used to build plugin assets before files are copied to plugin `trunk`. Eg `gulp build`
* `CUSTOM_PATH` - Some plugins tend to have a different folder inside git repository where the source files are kept aside from development files. If provided files will be copied from `CUSTOM_PATH` to plugin `trunk`.
* `EXCLUDE_LIST` 
  * Add file / folders that you wish to exclude from final list of files to be sent to plugin `trunk`. Eg development files. By default the script will exclude `.git .github` and `assets` if provided.
  * Final value of the above var is expected to be a string delimited with spaces. Eg: '.gitignore package.json README.md'
  * Please Note excluded file/folder path is considered from the root of repository unless `CUSTOM_PATH` is provided, in which case excluded file/folder path should be relative to the final source of files.

## Example Workflow File

```
workflow "Deploy" {
     resolves = ["WordPress Plugin Deploy"]
     on = "push"
   }
   
   # Filter for tag
   action "tag" {
       uses = "actions/bin/filter@master"
       args = "tag"
   }
   
   action "WordPress Plugin Deploy" {
     needs = ["tag"]
     uses = "rtCamp/github-actions-library/wp-plugin-deploy@master"
     secrets = ["WORDPRESS_USERNAME", "WORDPRESS_PASSWORD"]
     env = {
       SLUG = "plugin-slug"
       CUSTOM_COMMAND = "gulp build"
       CUSTOM_PATH = "post-contributor"
       EXCLUDE_LIST = "asset_sources/"
     }
   }
```

## Credits

* Github action bootstrapped from - [10up/actions-wordpress/dotorg-plugin-deploy](https://github.com/10up/actions-wordpress/tree/master/dotorg-plugin-deploy)
* Deployment Docker Image - [awhalen/docker-php-composer-node](https://github.com/amwhalen/docker-php-composer-node)  
