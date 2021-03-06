# Copyright 2012-2013 Institut National des Sciences Appliquées de Lyon (INSA-Lyon)
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

VERSION='0-preview2-SNAPSHOT'
DIST_BIN_PATH = "target/gololang-#{VERSION}-distribution/gololang-#{VERSION}/bin"

task :default => [:all]

desc "Build a complete distribution (packages + documentation)"
task :all => [:doc, :rebuild]

desc "Clean"
task :clean do
  sh "mvn clean"
  Dir.chdir("golo-maven-plugin") do
    sh "mvn clean"
  end
end

desc "Build and install"
task :build do
  sh "mvn install"
end

desc "Clean, build and install"
task :rebuild do
  sh "mvn clean install"
end

desc "Build the documentation"
task :doc do
  Dir.chdir("doc") do
    sh "rake clean all"
  end
end

desc "Release"
task :release => [:clean, :all] do
  MAGIC = "mvn deploy -P sonatype-oss-release"
  sh MAGIC
  Dir.chdir("golo-maven-plugin") do
    sh MAGIC
  end
end

namespace :run do

  desc "Run golo"
  task :golo, :arguments do |t, args|
    sh "#{DIST_BIN_PATH}/golo #{args.arguments}"
  end

  desc "Run goloc"
  task :goloc, :arguments do |t, args|
    sh "#{DIST_BIN_PATH}/goloc #{args.arguments}"
  end

  desc "Run gologolo"
  task :gologolo, :arguments do |t, args|
    sh "#{DIST_BIN_PATH}/gologolo #{args.arguments}"
  end

end

namespace :test do

  desc "Run all tests"
  task :all do
    sh "mvn test"
  end

  desc "Run all tests with JaCoCo code coverage"
  task :all_jacoco do
    sh "mvn test -P test-coverage"
  end

  desc "Parser tests (verbose)"
  task :parser do
    sh "mvn test -Dtest=ParserSanityTest -P verbose-tests"
  end

  desc "IR tests (verbose)"
  task :visitors do
    sh "mvn test -Dtest=ParseTreeToGoloIrAndVisitorsTest -P verbose-tests"
  end

  desc "Bytecode compilation output tests (verbose)"
  task :bytecode do
    sh "mvn test -Dtest=CompilationTest -P verbose-tests"
  end

  desc "Samples compilation and running tests (verbose)"
  task :run do
    sh "mvn test -Dtest=CompileAndRunTest -P verbose-tests"
  end

  desc "Standard library classes"
  task :stdlib do
    sh "mvn test -Dtest=gololang.*"
  end

end

namespace :special do
  
  desc "Bootstrap Golo and the Maven plug-in for a clean-room environment"
  task :bootstrap do
    sh "mvn clean install -P !bootstrapped"
    Dir.chdir("golo-maven-plugin") do
      sh "mvn clean install"
    end
    sh "mvn clean install"
  end

end
