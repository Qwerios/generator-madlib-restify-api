module.exports = (grunt) ->
    # Load package details
    #
    pkg = grunt.file.readJSON( "package.json" )

    # Project configuration
    #
    grunt.initConfig
        # Provide package details for grunt
        #
        pkg: pkg

        # Clean the distribution folder
        #
        clean:
            dist:
                src: [ "dist" ]

            coverage:
                src: [ "dist/coverage" ]

        # Prepare the distribution folder
        #
        copy:
            dist:
                files:
                    [
                        expand: true
                        src:
                            [
                                "src/**"
                                "static_content/**"
                                "log/FOLDER.md"
                                "index.js"
                                "package.json"
                                "README.md"
                            ]
                        dest: "dist/source"
                    ]

        # Create the distribution archive
        #
        compress:
            dist:
                options:
                    archive: "dist/artifacts/" + pkg.name + "-" + pkg.version + ".zip"
                expand: true
                cwd:    "dist/source/"
                src:    [ "**/*" ]
                dest:   pkg.name

        mochaTest:
            dev:
                options:
                    reporter:       "spec"
                    require:        [ "coffee-script/register", "test/blanket" ]
                src: [
                    "test/unit/*.js"
                    "test/unit/*.coffee"
                    "test/api/*.js"
                    "test/api/*.coffee"
                    "test/route/*.js"
                    "test/route/*.coffee"
                ]

            "test-xunit":
                options:
                    reporter:       "xunit"
                    captureFile:    "dist/coverage/test-results.xml"
                    quiet:          true
                    require:        [ "coffee-script/register", "test/blanket" ]
                src: [
                    "test/unit/*.js"
                    "test/unit/*.coffee"
                    "test/api/*.js"
                    "test/api/*.coffee"
                    "test/route/*.js"
                    "test/route/*.coffee"
                ]

            "coverage-cobertura":
                options:
                    reporter:       "mocha-cobertura-reporter"
                    captureFile:    "dist/coverage/coverage.xml"
                    quiet:          true
                    coverage:       true
                src: [
                    "test/unit/*.js"
                    "test/unit/*.coffee"
                    "test/api/*.js"
                    "test/api/*.coffee"
                    "test/route/*.js"
                    "test/route/*.coffee"
                ]

            "coverage-html":
                options:
                    reporter:       "html-cov"
                    captureFile:    "dist/coverage/coverage.html"
                    quiet:          true
                    coverage:       true
                src: [
                    "test/unit/*.js"
                    "test/unit/*.coffee"
                    "test/api/*.js"
                    "test/api/*.coffee"
                    "test/route/*.js"
                    "test/route/*.coffee"
                ]

    # These plugins provide the necessary tasks
    #
    grunt.loadNpmTasks "grunt-contrib-clean"
    grunt.loadNpmTasks "grunt-contrib-copy"
    grunt.loadNpmTasks "grunt-contrib-compress"
    grunt.loadNpmTasks "grunt-mocha-test"

    # Default tasks
    #
    grunt.registerTask "default",   [ "clean:dist", "copy:dist", "compress:dist" ]
    grunt.registerTask "test",      [ "mochaTest:dev" ]
    grunt.registerTask "coverage",  [ "clean:coverage", "mochaTest:test-xunit", "mochaTest:coverage-cobertura", "mochaTest:coverage-html" ]
