package;

import utest.Runner;
import utest.ui.Report;

class Main {
	public static function main() {
		var runner = new Runner();
		
		Report.create(runner);
		runner.run();
	}
}