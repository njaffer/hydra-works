module Hydra::Works
  class UploadToGenericFile

    # Upload a file to a generic file, optionally running auto-generation services to create variants.
    #
    # @param [Hydra::Works::GenericFile] :generic_file into which to upload the file
    # @param [String] :path_to_file path to the file being uploaded
    # @param [Hash] :auto_gen_services info for auto-generating files from the uploaded content file
    # @param [boolean] :replace if true, delete all files before processing; if false, delete all auto-gen files and version content
    #
    # @return [Hydra::Works::GenericFile] the updated generic file

    def self.call( gfile, path_to_file, auto_gen_services={}, replace=false )

      #  behavior restriction - generic_file can have only one content file + associated auto-generated files
      #       - TODO: if a content file already exists, is the new file a new version?

      #  what is the temp path for holding auto-gen files

      #  auto_gen_services hash:  Which of the following info needs to be in the hash?
      #   - call back or block to run the auto-gen service
      #   - predicate for defining use
      #   - use predicate value
      #   - attributes - additional attributes to apply to just this service

      # TODO Should this service schedule file characterization for uploaded file?

      raise ArgumentError, "parent_generic_file must be a works generic file" unless Hydra::Works.generic_file? parent_generic_file
      raise ArgumentError, "path_to_file must be a String" unless path_to_file.is_a? String

      upload_file     = Hydra::Works::CreateFileWithUpload.call( path_to_file )
      upload_file.use = Hydra::Works.CONTENT
      Hydra::Works::AddFileToGenericFile( gfile, upload_file )

      # loop through services and do for each...
      #
      auto_gen_services.each do |s|
        path_to_generated_file = Hydra::Works::AutoGenerateVariant.call( path_to_file, s[:generator_service] )
        unless path_to_generated_file.nil?
          generated_file = Hydra::Works::CreateFileWithUpload.call( path_to_generated_file )
          generated_file.use = s[:use]
          Hydra::Works::AddFileToGenericFile( generic_file, generated_file )
        end
      end

      generic_file
    end

  end
end







# C Cole	10:49 AM
# https://wiki.duraspace.org/display/hydra/Service+Object+Approach
# https://github.com/projecthydra-labs/worthwhile/blob/master/app/controllers/curation_concern/generic_works_controller.rb#L4
# https://github.com/projecthydra/sufia/blob/master/app/controllers/concerns/sufia/files_controller_behavior.rb#L44-L46
# https://github.com/projecthydra/sufia/blob/master/app/controllers/concerns/sufia/files_controller_behavior.rb#L149-L151
#
# me	11:05 AM
# https://wiki.duraspace.org/x/2QQdB
#
# C Cole	11:06 AM
# http://apidock.com/rails/ActiveRecord/Base/update_attributes
# https://github.com/psu-stewardship/scholarsphere/blob/develop/app/models/generic_file.rb
# https://github.com/projecthydra/sufia/blob/master/sufia-models/app/models/concerns/sufia/generic_file/metadata.rb
# https://github.com/projecthydra/sufia/blob/pcdm-integration/app/controllers/concerns/sufia/generic_works_controller_behavior.rb#L31
#
# me	11:26 AM
# https://gist.github.com/elrayle/a40054e93216377ba7ce
#
# C Cole	11:27 AM
# https://github.com/projecthydra/sufia/blob/master/sufia-models/app/actors/sufia/generic_file/actor.rb#L31-L39
# https://github.com/projecthydra/sufia/blob/pcdm-integration/spec/actors/generic_file/actor_spec.rb
# psugirlinpa

