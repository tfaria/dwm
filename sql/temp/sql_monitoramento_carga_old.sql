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
ORDER BY A.HorarioInicio DESC