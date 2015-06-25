# Assets (should have the loweest priority)
ReportWorker::Parser.add(ReportWorker::Parser::Asset::Computer, 10)

# Components (should have a middle priority as they require assets)
ReportWorker::Parser.add(ReportWorker::Parser::Status::CpuTemperature, 20)

# Statuse (should have the highest priority as they require assets and components)
ReportWorker::Parser.add(ReportWorker::Parser::Component::Cpu, 50)
ReportWorker::Parser.add(ReportWorker::Parser::Component::Nic, 50)
