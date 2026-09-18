#include <cpptrace/cpptrace.hpp>
#include <ng-log/logging.h>

#include "base/GameApplication.h"

#define __ONNX_DISABLE_STATIC_REGISTRATION 1

#include <fstream>
//#include <onnxruntime_cxx_api.h>
#include <piper.h>

int main(int argc, char* argv[])
{
    piper_synthesizer* synth = piper_create(
        "resources/voice/models/en_US-amy-medium.onnx",
        "resources/voice/models/en_US-amy-medium.onnx.json",

        "resources/voice/models/espeak-ng-data"
    );

    // aplay -r 22050 -c 1 -f FLOAT_LE -t raw output.raw
    std::ofstream audio_stream("output.raw", std::ios::binary);

    piper_synthesize_options options = piper_default_synthesize_options(synth);
    // Change options here:
    // options.length_scale = 2;
    // options.speaker_id = 5;

    piper_synthesize_start(synth, "Welcome to the world of speech synthesis!",
                           &options /* NULL for defaults */);

    piper_audio_chunk chunk;
    while (piper_synthesize_next(synth, &chunk) != PIPER_DONE) {
        audio_stream.write(reinterpret_cast<const char *>(chunk.samples),
                           chunk.num_samples * sizeof(float));
    }

    piper_free(synth);

    return 0;

	int return_code = 1;

	CPPTRACE_TRY
	{
		GameApplication app(argc, argv);

		return_code = app.exec();
	}
	CPPTRACE_CATCH(const std::exception& exc)
	{
		LOG(ERROR) << "Exception in main" << exc.what() << std::endl << 
			cpptrace::from_current_exception().to_string();
	}

	return return_code;
}
