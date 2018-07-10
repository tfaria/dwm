SELECT DESCRICAOPACOTE,HORARIOINICIO,HORARIOFIM,TEDT_NM_DIA_SEMANA,DESCRICAOPACOTE,CAST(DATEDIFF(SECOND,HORARIOINICIO,ISNULL(HORARIOFIM,GETDATE())) AS DECIMAL(8,2))/3600 DIFMIN--,*
FROM BUICTRDBS..AUDIT_LOGEXECUCAOPACOTE A
	JOIN BIDASA..DIM_TEMPO_DATA
		ON TEDT_DT_TEMPO_DATA = CONVERT(VARCHAR(8),HORARIOINICIO,112)
--WHERE DESCRICAOPACOTE IN ('BUI_SEQ_CUBOS','BUI_SEQ_FATO','BUI_SEQ_ODS')
WHERE DESCRICAOPACOTE LIKE ('%QKV%')
AND HORARIOINICIO >= GETDATE()-5
AND HORARIOINICIO <= GETDATE()
--AND DATEDIFF(HH,HORARIOINICIO,HORARIOFIM) > 0
AND SERVIDOREXEC = 'MTZSQL20'
AND USUARIOEXEC = 'ARAUJOCORP\SVC_SQLCLBI'
--AND USUARIOEXEC = 'ARAUJOCORP\THIAGO.FARIA'
--AND HORARIOINICIO > '2016-02-03 13:16:00.760'
ORDER BY A.DESCRICAOPACOTE,HORARIOINICIO

--SELECT CAST(DATEDIFF(SECOND,'2016-12-01 07:39:04.730', 


/*****************************************************************************/
/************************MONITORAMENTO CARGA**********************************/
/*****************************************************************************/

DECLARE @STATUS_EXEC INT

SELECT @STATUS_EXEC = A.StatusPacote
FROM BUICTRDBS.dbo.Audit_LogExecucaoPacote A (NOLOCK)
WHERE A.HorarioInicio = (SELECT MAX(B.HorarioInicio) FROM BUICTRDBS.dbo.Audit_LogExecucaoPacote B (NOLOCK))

SELECT DISTINCT RUN_STATUS, @STATUS_EXEC AS ULT_STATUS_EXEC
FROM MSDB.dbo.SYSJOBS NJOB (NOLOCK)
JOIN MSDB.dbo.SYSJOBHISTORY JOB (NOLOCK)
	ON NJOB.job_id = JOB.job_id
WHERE NJOB.NAME = 'BI_ETL_CARGA'
AND	RUN_DATE >= CONVERT(INT,CONVERT(CHAR(8),GETDATE(),112))

SELECT A.DescricaoPacote, 
	A.HorarioInicio, 
	A.HorarioFim, 
	CASE StatusPacote WHEN 2 THEN 'ERRO' WHEN 0 THEN 'EM ANDAMENTO' ELSE 'SUCESSO' END ST,
	A.ErroTarefa 
FROM BUICTRDBS.dbo.Audit_LogExecucaoPacote A (NOLOCK)
WHERE HorarioInicio >= CONVERT(CHAR(8),GETDATE(),112)
--and StatusPacote in (0,2)
--and DescricaoPacote like'%qlik%'
--and HorarioInicio >= '2016-09-03 07:18:00.277'
ORDER BY A.HorarioInicio DESC

