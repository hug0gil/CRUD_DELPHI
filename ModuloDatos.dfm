object DataModuleBDD: TDataModuleBDD
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 150
  Width = 215
  object pFIBDatabase: TpFIBDatabase
    DBName = 'C:\Users\Pr1\DataBases\BDDCRUD.FDB'
    DBParams.Strings = (
      'user_name=SYSDBA'
      'password=hugoAstec'
      'lc_ctype=ISO8859_1')
    DefaultTransaction = pFIBTransaction
    DefaultUpdateTransaction = pFIBTransaction
    SQLDialect = 3
    Timeout = 0
    LibraryName = 'C:\Windows\System32\FBCLIENT.DLL'
    WaitForRestoreConnect = 0
    Left = 48
    Top = 48
  end
  object pFIBTransaction: TpFIBTransaction
    DefaultDatabase = pFIBDatabase
    TimeoutAction = TARollback
    Left = 136
    Top = 48
  end
end
