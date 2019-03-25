/*
Alejandro Bermudez Lara
Ejercicio 1
*/
#include <getopt.h>
#include <sys/types.h>
#include <unistd.h>
#include <ctype.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <pwd.h>	//The pwd.h header shall provide a definition for struct passwd
#include <grp.h>	/*The grp.h header shall declare the structure group which shall include the name of the group, numerical group ID, Pointer to a null-terminated array of character pointers to member names*/

//Declaracion de funciones
void nombreUsuario(char *username);
void idUsuario(int idUser);
void nombreGrupo(char *name);
void uidGrupo(int uid);
void showAllSystemGroups();
void showAllInfo(char *username);
void showCurrentUserGroupInfo();
void help();

//Funcion principal
int main (int argc, char **argv)
{
	char *uvalue = NULL;
	char *ivalue = NULL;
	char *gvalue = NULL;
	int dvalue = 0;
	int sflag = 0;
	char *avalue = NULL;
	int bflag = 0;
	int hflag = 0;
	int index;
	int i;
	int c;
	char *user = getlogin();


	/*Estructura a utilizar por getoptlong */
	static struct option long_options[] =
	{
		/* Opciones que no van a actuar sobre un flag */
		/* "opcion", recibe o no un argumento, 0,
		   identificador de la opción */
		{"username", required_argument, 0, 'u'},
		{"useruid", required_argument, 0, 'i'},
		{"groupname", required_argument, 0, 'g'},
		{"groupuid", required_argument, 0, 'd'},
		{"allgroups", no_argument, 0, 's'},
		{"allinfo", required_argument, 0, 'a'},
		{"bactive", no_argument, 0, 'b'},
		{"help", no_argument, 0, 'h'},
		/* Necesario para indicar el final de las opciones */
		{0, 0, 0, 0}
	};

	/* getopt_long guardará el índice de la opción en esta variable. */
	int option_index = 0;

	/*Si no ponemos manualmente a cero la variable OPTERR y el primer caracter de optstring no es <:>,
	getopt() imprime un mensaje de diagnostico a stderr en el formato específico de la utilidad getops*/
	opterr = 0;

	while ((c = getopt_long (argc, argv, "u:i:g:d:sa:bh", long_options, &option_index)) != -1)
	{
		// Podemos observar qué pasa con las variables externas que va gestionando
	        //   getopt() durante las sucesivas llamadas.
	        //   - optind: Indice del siguiente elemento a procesar del vector argv[]
	        //   - optarg: recoge el valor del argumento obligario de una opcion.		        //   - optopt: recoge el valor de la opcion cuando es desconocida (?) o INCOMPLETA respecto a las opciones indicadas.

		switch (c)
		{
			/*La opción -u/--username servirá para especificar el nombre de un usuario del sistema (p.ej. jfcaballero) del cual hay que mostrar la información correspondiente a su estructura passwd.*/
			case 'u':
				uvalue = optarg; //En optarg se guarda el valor de argumento obligatorio que requiere u
			break;

			/*La opción -i/--useruid servirá para especiﬁcar el identiﬁcador de un usuario del sistema (p.ej. 17468) del cual hay que mostrar la información correspondiente a su estructura passwd . */
			case 'i':
				ivalue = optarg;
			break;

			/*La opción -g/--groupname, servirá para especificar el nombre de un grupo del sistema (p.ej. adm) del cual hay que mostrar la información correspondiente a su estructura group (GID).*/
			case 'g':
				gvalue = optarg;
			break;

			case 'd':
				dvalue = atoi(optarg);
			break;

			case 's':
				sflag = 1;
			break;

			case 'a':
				avalue = optarg;
			break;

			case 'b':
				bflag = 1;
			break;

			case 'h':
				hflag = 1;
			break;

			case '?':
				if (optopt == 'u' || optopt == 'i' || optopt == 'g' || optopt == 'd' || optopt == 'a') //Para el caso de que 'u' no tenga el argumento obligatorio.
					fprintf(stderr, "La opcion %c requiere un argumento. Valor de opterr = %d\n", optopt, opterr);
				else if (isprint (optopt)) //Comprueba si el caracter es imprimible
					fprintf (stderr, "Opción desconocida \"-%c\". Valor de opterr = %d\n", optopt, opterr);
				else //Caracter especial o no imprimible
					fprintf(stderr, "Caracter `\\x%x'. Valor de opterr = %d\n", optopt, opterr);
				return 1; //finaliza el programa
			default:
				abort();
		}
		//printf("optind: %d, optarg: %s, optopt: %c, opterr: %d\n\n", optind, optarg, optopt, opterr);
	}

	if (uvalue)
	{
		nombreUsuario(uvalue);
	}
	else if (ivalue)
	{
		idUsuario(atoi(ivalue));
	}
	else if (gvalue)
	{
		nombreGrupo(gvalue);
	}
	else if(dvalue)
	{
		uidGrupo(dvalue);
	}
	else if(sflag)
	{
		showAllSystemGroups();
	}
	else if(avalue)
	{
		showAllInfo(avalue);
	}
	else if(bflag)
	{
		showCurrentUserGroupInfo();
	}
	else if(hflag)
	{
		help();
	}
	else
	{
		showAllInfo(user);
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
	printf("\nuvalue = %s, ivalue = %s, gvalue = %s, dvalue = %d, sflag = %d, avalue = %s, bflag = %d, hflag = %d\n", uvalue, ivalue, gvalue, dvalue, sflag, avalue, bflag, hflag);

	return 0;
}

//Funciones
//Funcion que servirá para especificar el usuario por nombre de usuario (p.ej. i82fecaj) del cual hay que mostrar la información correspondiente a su estructura passwd.
void nombreUsuario(char *username)
{
	char *lgn = username;
	struct passwd *pw;

	if ((pw = getpwnam(lgn)) == NULL)
	{
		fprintf(stderr, "No se pudo recuperar la información de usuario. Nombre de usuario erroneo\n");
    		exit(1);
	}
	else
	{
		printf("Nombre del usuario: %s\n", pw -> pw_gecos);
		printf("Login: %s\n", pw->pw_name);
	  	printf("Contraseña: %s\n", pw -> pw_passwd);
		printf("Id del usuario: %d\n", pw -> pw_uid);
		printf("Directorio HOME: %s\n", pw -> pw_dir);
		printf("Interprete predeterminado:%s\n", (*pw).pw_shell);
	}

}

//La opción -i/--useruid servirá para especificar el identificador de un usuario del sistema (p.ej. 17468) del cual hay que mostrar la información correspondiente a su estructura passwd .
void idUsuario(int idUser)
{
	int id = idUser;
	struct passwd *pw;

	if ((pw = getpwuid(id)) == NULL)
	{
		fprintf(stderr, "No se pudo recuperar la información de usuario. Identificador de usuario erroneo.\n");
    		exit(EXIT_FAILURE);
	}
	else
	{
		printf("---------------\n");
		printf("Nombre del usuario: %s\n", pw -> pw_gecos);
		printf("Id del usuario: %d\n", pw -> pw_uid);
		printf("Contraseña: %s\n", pw -> pw_passwd);
		printf("Carpeta Inicio: %s\n", pw -> pw_dir);
		printf("Interprete por defecto:%s\n", (*pw).pw_shell);
		printf("Login de usuario: %s\n", pw->pw_name);
		printf("---------------\n");
	}

}

void nombreGrupo(char *name)
{
	char *groupName = name;
	struct group *gr;

	if ((gr = getgrnam(groupName)) == NULL )
	{
		fprintf(stderr, "Fue imposible recuperar la informacion del usuario. Nombre de grupo erroneo.\n");
    		exit(EXIT_FAILURE);
	}
	else
	{
		printf("Numero de grupo principal: %d\n", gr -> gr_gid);
	}
}

void uidGrupo(int uid)
{
	int userID = uid;
	struct group *gr;

	if ((gr = getgrgid(userID)) == NULL )
	{
		fprintf(stderr, "Fue imposible recuperar la informacion del usuario. UID de grupo erroneo.\n");
    		exit(1);
	}
	else
	{
		printf("Nombre de grupo principal: %s\n", gr -> gr_name);
	}
}

void showAllSystemGroups()
{
	struct group *gr;

	//The setgrent() function rewinds to the beginning of the group database, to allow repeated scans.
	setgrent();

	/*The  getgrent()  function  returns  a pointer to a structure containing the broken-out fields of a record in the group database (e.g., the local group file /etc/group, NIS, and LDAP).  The first time getgrent() is  called,  it  returns  the  first  entry; thereafter, it returns successive entries.*/
	while (gr = getgrent())
	{
		printf("Nombre de grupo principal: %s\n", gr->gr_name);
		printf("Numero de grupo principal: %d\n", gr -> gr_gid);
		printf("---------------\n");

	}

	endgrent();

}

void showAllInfo(char *username)
{
	char *lgn = username;
	struct passwd *pw;
	struct group *gr;
	char *lang = "LANG";

	if(strstr(getenv("LANG"), "en_EN"))
	{
		if ((pw = getpwnam(lgn)) == NULL)
		{
			fprintf(stderr, "No se pudo recuperar la información de usuario. Nombre de usuario erroneo\n");
	    		exit(1);
		}
		else
		{
			//información correspondiente a su estructura passwd
			printf("---------------\n");
			printf("Username: %s\n", pw -> pw_gecos);
			printf("User ID: %d\n", pw -> pw_uid);
			printf("Password: %s\n", pw -> pw_passwd);
			printf("Home folder: %s\n", pw -> pw_dir);
			printf("Default interpreter:%s\n", (*pw).pw_shell);
			printf("User login: %s\n", pw->pw_name);

			printf("\n");

			//información correspondiente a su estructura group
			printf("Main group number: %d\n", pw->pw_gid);
			gr = getgrgid(pw->pw_gid);
			printf("Main group name: %s\n", gr->gr_name);
			printf("---------------\n");
		}
	}
	else
	{
		if ((pw = getpwnam(lgn)) == NULL)
		{
			fprintf(stderr, "No se pudo recuperar la información de usuario. Nombre de usuario erroneo\n");
	    		exit(1);
		}
		else
		{
			//información correspondiente a su estructura passwd
			printf("---------------\n");
			printf("Nombre del usuario: %s\n", pw -> pw_gecos);
			printf("Id del usuario: %d\n", pw -> pw_uid);
			printf("Contraseña: %s\n", pw -> pw_passwd);
			printf("Carpeta Inicio: %s\n", pw -> pw_dir);
			printf("Interprete por defecto:%s\n", (*pw).pw_shell);
			printf("Login de usuario: %s\n", pw->pw_name);

			printf("\n");

			//información correspondiente a su estructura group
			printf("Número de grupo principal: %d\n", pw->pw_gid);
			gr = getgrgid(pw->pw_gid);
			printf("Nombre del grupo principal: %s\n", gr->gr_name);
			printf("---------------\n");
		}
	}

}

void showCurrentUserGroupInfo()
{
	char *lgn;
	struct passwd *pw;
	struct group *gr;

	if((lgn = getlogin()) == NULL || (pw = getpwnam(lgn)) == NULL)
	{
		fprintf(stderr, "No se pudo recuperar la información de usuario actual.\n");
		exit(1);
	}

	printf("Número de grupo principal: %d\n", pw->pw_gid);

	/*Obtenemos la estructura de información del grupo
	a través del número de grupo al que pertenece el usuario*/
	gr = getgrgid(pw->pw_gid);

	printf("Nombre del grupo principal: %s\n", gr->gr_name);
}

void help()
{
	printf("\tUso del programa: ejercicio1 [opciones]\n");
	printf("\tOpciones:\n");
	printf("\t-h, --help		Imprimir esta ayuda\n");
	printf("\t-u, --username        Nombre de Usuario\n");
	printf("\t-i, --useruid         Identificador de Usuario\n");
	printf("\t-g, --groupname       Nombre de Grupo\n");
	printf("\t-d, --groupuid        Identificador de Grupo\n");
	printf("\t-s, --allgroups       Muestra info de todos los grupos del sistema\n");
	printf("\t-a, --allinfo         Nombre de Usuario\n");
	printf("\t-b, --bactive         Muestra info grupo usuario Actual\n");

}
