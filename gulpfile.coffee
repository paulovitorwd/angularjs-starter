#### Loaders
gulp        = require 'gulp'
runSequence = require 'run-sequence'
cache       = require 'gulp-angular-templatecache'
jshint      = require 'gulp-jshint'
compass     = require 'gulp-compass'
clean       = require 'gulp-clean'
useref      = require 'gulp-useref'
gulpif      = require 'gulp-if'
htmlmin     = require 'gulp-htmlmin'
cssnano     = require 'gulp-cssnano'
uglify      = require 'gulp-uglify'
replace     = require 'gulp-replace'
browserSync = require 'browser-sync'


#### Config
root_folder   = './'
dev_folder    = 'dev/'
dist_folder   = 'dist/'
htaccess_file = '.htaccess'
compass_file  = 'config.rb'
index_file    = 'index.html'
cache_file    = 'dev/templates.js/'
js_files      = 'dev/app/**/*.js'
scss_folder   = 'dev/scss/'
scss_files    = 'dev/scss/**/*.scss'
assets_files  = 'dev/assets/**/*'
css_folder    = 'dev/assets/stylesheets/'
css_files     = 'dev/assets/stylesheets/**/*'
app_files     = 'dev/app/**/*'
html_files    = 'dev/app/**/*.html'
assets_folder = 'dist/assets/'
app_folder    = 'dist/app/'
server =
    dev:
        server: 'dev',
        port:  3000
    dist:
        server: 'dist',
        port:  4000
deploy =
    work:    'http://localhost:3000/'
    build:   'http://localhost:4000/'
    prod:    'http://paulofrontend.com.br/'


#### Registers
gulp.task 'default', ->
    console.log '=============================='
    console.log '                              '
    console.log '    Use commands:             '
    console.log '      \'$ gulp compile\'      '
    console.log '      \'$ gulp watch\'        '
    console.log '      \'$ gulp build\'        '
    console.log '      \'$ gulp check\'        '
    console.log '      \'$ gulp prod\'         '
    console.log '                              '
    console.log '=============================='

gulp.task 'compile', (done) ->
    runSequence 'cache', 'jshint', 'scss', done


gulp.task 'watch', ['compile'], ->
    browserSync.init server.dev

    gulp.watch html_files, ['cache']
    gulp.watch js_files,   ['jshint']
    gulp.watch scss_files, ['scss']
    gulp.watch([
        dev_folder + index_file,
        app_files
    ]).on 'change', browserSync.reload


# gulp.task 'build', ['compile'], (done) ->
#     runSequence 'clean', 'copy', 'partials-min', 'index-min', 'redirect-build', 'deploy-build', done
#
#
# gulp.task 'check', ['build'], ->
#     browserSync.init server.dist
#
#
# gulp.task 'prod', ['build'], ->
#     runSequence 'redirect-prod', 'deploy-prod'


#### Units
gulp.task 'cache', ->
    gulp.src html_files
        .pipe cache()
        .pipe gulp.dest dev_folder


gulp.task 'jshint', ->
    gulp.src js_files
        .pipe jshint()
        .pipe jshint.reporter('default')


gulp.task 'scss', ->
    gulp.src css_folder
        .pipe clean()

    gulp.src scss_files
        .pipe compass
            config_file: compass_file
            sass:        scss_folder
            css:         css_folder
        .on 'error', ->
            process.exit 1
        .pipe gulp.dest css_folder
        .pipe browserSync.stream()


# gulp.task 'clean', ->
#     gulp.src dist_folder, read: false
#         .pipe clean()
#
#
# gulp.task 'copy', ->
#     gulp.src dev_folder + htaccess_file
#         .pipe gulp.dest dist_folder
#
#     gulp.src [
#             assets_files,
#             '!' + css_files
#         ]
#         .pipe gulp.dest assets_folder
#
#
# gulp.task 'partials-min', ->
#     gulp.src html_files
#         .pipe useref()
#         .pipe gulpif '*.html', htmlmin(
#             removeComments: true
#             collapseWhitespace: true
#         )
#         .pipe gulp.dest app_folder
#
#
# gulp.task 'index-min', ->
#     gulp.src dev_folder + index_file
#         .pipe useref()
#         .pipe gulpif '*.css', cssnano()
#         .pipe gulpif '*.js', uglify()
#         .pipe gulpif '*.html', htmlmin(
#             removeComments: true
#             collapseWhitespace: true
#         )
#         .pipe gulp.dest dist_folder
#
#
# gulp.task 'deploy-build', ->
#     gulp.src dist_folder + index_file
#         .pipe replace deploy.work, deploy.build
#         .pipe replace deploy.homolog, deploy.build
#         .pipe replace deploy.prod, deploy.build
#         .pipe gulp.dest dist_folder
#
#
# gulp.task 'deploy-prod', ->
#     gulp.src dist_folder + index_file
#         .pipe replace deploy.build, deploy.prod
#         .pipe gulp.dest dist_folder