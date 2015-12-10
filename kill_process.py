import psutil       #http://pythonhosted.org/psutil/
import argparse     #https://docs.python.org/3/library/argparse.html

def CrearArgParseo():
	parser = argparse.ArgumentParser(prog='kill_process.exe', description='Script para matar todos los procesos que tengan un determinado nombre.')
	parser.add_argument('-p', '--proceso', help='Nombre del proceso a matar, por ejemplo: "explorer.exe".')
	parser.add_argument('-f', '--file', help='Nombre que tendra el fichero de log.')
	parser.add_argument('-v', '--verbose', action='store_true', help='Verbose flag.', default=False)
	
	parser.set_defaults(proceso='tvnserver.exe', file='kill.log') # tambien lo puedo poner en la misma linea
	#parser.print_help()
	return parser.parse_args()


def CreaFichero(texto, nombre='kill.log'):
	with open(nombre, 'a') as file:
		file.write(texto)


def BuscaProceso(proceso, fich):
	#hacer un modo verbose
	for proc in psutil.process_iter(): # lista de todos los procesos del sistema
		try:
			pinfo = proc.as_dict(attrs=['pid', 'name']) # los convierto en un diccionario, algunos no tienen esos valores y daria error
		except psutil.NoSuchProcess:
			pass
		else:
			if pinfo['name']==proceso:
				CreaFichero('%s. Proceso: %s con pid: %s. Eliminado.\n'%(time.strftime("%Y/%m/%d %H:%M:%S"), pinfo['name'], pinfo['pid']), fich)
				proc.terminate()  # ==os.kill(pid, signal.SIGTERM)

def main():
	arg = CrearArgParseo()
	#print arg.proceso
	#print arg.file
	BuscaProceso(arg.proceso, arg.file)

main()
