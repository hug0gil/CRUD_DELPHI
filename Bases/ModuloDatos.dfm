object DataModuleBDD: TDataModuleBDD
  OnCreate = DataModuleCreate
  Height = 480
  Width = 640
  object FDTransaction: TFDTransaction
    Options.AutoStop = False
    Options.DisconnectAction = xdRollback
    Connection = DataBaseFDConnection
    Left = 400
    Top = 168
  end
  object DataBaseFDConnection: TFDConnection
    Params.Strings = (
      'Database=C:\Users\Pr1\DataBases\BDDCRUD.FDB'
      'Dialect=3'
      'CharacterSet=ISO8859_1'
      'User_Name=SYSDBA'
      'Password=hugoAstec'
      'DriverID=FB')
    Connected = True
    LoginPrompt = False
    Transaction = FDTransaction
    UpdateTransaction = FDTransaction
    Left = 272
    Top = 168
  end
end
