class IfStatement {
public: 
	int i;
	int c;
	IfStatement(int torf, int insr) {
		i = torf;
		c = insr;
	}
	int if_statement() {
		if (i == 1) {
			return c;
		}
		else return 0;
	}
};