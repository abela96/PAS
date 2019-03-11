/*
Alejandro Bermudez Lara
Ejercicio 1
*/

#include <unistd.h>
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <pwd.h>	//The pwd.h header shall provide a definition for struct passwd
#include <grp.h>	/*The grp.h header shall declare the structure group which shall include the name of the group, numerical group ID, Pointer to a null-terminated array of character pointers to member names*/

//Declaracion de funciones
void nombreUsuario(char *username);

//Funcion principal
int main (int argc, char **argv)
{
	char *uvalue = NULL;
	int index;
	int i;
	int c;

	/*Si no ponemos manualmente a cero la variable OPTERR y el primer caracter de optstring no es <:>,
	getopt() imprime un mensaje de diagnostico a stderr en el formato específico de la utilidad getops*/
	opterr = 0;

	while ((c = getopt (argc, argv, "u:")) != -1)
	{
		// Podemos observar qué pasa con las variables externas que va gestionando
	        //   getopt() durante las sucesivas llamadas.
	        //   - optind: Indice del siguiente elemento a procesar del vector argv[]
	        //   - optarg: recoge el valor del argumento obligario de una opcion.		        //   - optopt: recoge el valor de la opcion cuando es desconocida (?) o INCOMPLETA respecto a las opciones indicadas.

		switch (c)
		{
			/*La opción -u/--username servirá para especificar el nombre de un usuario del sistema (p.ej. jfcaballero) del cual hay que mostrar la información correspondiente a
			su estructura passwd.*/
			case 'u':
				uvalue = optarg; //En optarg se guarda el valor de argumento obligatorio que requiere c
			break;

			case '?':
				if (optopt == 'u') //Para el caso de que 'c' no tenga el argumento obligatorio.
					fprintf(stderr, "La opcion %c requiere un argumento. Valor de opterr = %d\n", optopt, opterr);
				else if (isprint (optopt)) //Comprueba si el caracter es imprimible
					fprintf (stderr, "Opción desconocida \"-%c\". Valor de opterr = %d\n", optopt, opterr);
				else //Caracter especial o no imprimible
					fprintf(stderr, "Caracter `\\x%x'. Valor de opterr = %d\n", optopt, opterr);
				return 1; //finaliza el programa
			default:
				abort();
		}
		printf("optind: %d, optarg: %s, optopt: %c, opterr: %d\n\n", optind, optarg, optopt, opterr);
	}

	if (uvalue)
	{
		nombreUsuario(uvalue);
	}

	/*Controla las opciones introducidas por el usuario que no hayan sido procesadas.
	Compara el número de argumentos recibidos con el número de opciones reconocidas*/
	/*Como getopt() internamente reordena los valores de argv, las primeras posiciones
	de argv corresponden a opciones conocidas y las últimas, a partir de optind,
	a opciones no reconocidas*/
	for(i=optind; i<argc; i++)
	{
		printf("Argumento \"%s\" de la línea de comandos que NO es una opción.\n", argv[i]);
	}

	//Visualiza las opciones que se han activad, asi como sus argumentos
	printf("\nuvalue = %s\n", uvalue);

	return 0;
}

//Funciones
//Funcion que servirá para especificar el usuario por nombre de usuario (p.ej. i82fecaj)
void nombreUsuario(char *username)
{
	char *lgn = username;
	struct passwd *pw;
    	struct group *gr;

	if ((lgn = getlogin()) == NULL || (pw = getpwnam(lgn)) == NULL)
	{
		fprintf(stderr, "No se pudo recuperar la información de usuario\n");
    		exit(1);
	}

	printf("Nombre del usuario: %s\n", pw -> pw_gecos);
  	printf("Contraseña: %s\n", pw -> pw_passwd);
	printf("Id del usuario: %d\n", pw -> pw_uid);
	printf("Directorio HOME: %s\n", pw -> pw_dir);
	printf("Interprete predeterminado:%s\n", (*pw).pw_shell);
}
