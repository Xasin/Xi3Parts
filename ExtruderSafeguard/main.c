
#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/wdt.h>

#include <util/delay.h>

#define TRIGGER_HIGH 34
#define TRIGGER_LOW	1000

/* COMMANDS:

avr-gcc -mmcu=attiny13 -DF_CPU=128000 -Os main.c -o main.elf
avr-objcopy -j .text -j .data -O ihex main.elf main.hex
avrdude -p t13 -P /dev/ttyACM0 -c stk500 -U flash:w:main.hex */

uint8_t mcusr_mirror __attribute__ ((section (".noinit")));
void get_mcusr(void) \
	__attribute__((naked)) \
	__attribute__((section(".init3")));
void get_mcusr(void)
{
	mcusr_mirror = MCUSR;
	MCUSR = 0;
	wdt_disable();

	if((mcusr_mirror & (1<< WDRF)) != 0) while(1) {}
}

ISR(ADC_vect) {
	if((ADC > TRIGGER_HIGH) && (ADC < TRIGGER_LOW))
		wdt_reset();
}

int main() {
	wdt_enable(WDTO_500MS);
	wdt_reset();

	// Relay-Controlling pin enable
	DDRB = 1;
	PORTB = 1;

	// Initialisation of the ADC:
	ADMUX = (1<< MUX0);	// Select PB2 (ADC1), Vcc as VRef
	// ADC Enabled, Start conversion, Free-Running mode, Interrupt-enable, Prescaler 2 (for 128kHz OSC)
	ADCSRA = (1<< ADEN | 1<< ADSC | 1<< ADATE | 1<< ADIE);

	sei();

	// Loop & let the ISR & Watchdog work
	while(1) {}
}
