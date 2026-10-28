#include <cpptrace/cpptrace.hpp>
#include <ng-log/logging.h>

#include "base/GameApplication.h"

int main(int argc, char* argv[])
{
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
