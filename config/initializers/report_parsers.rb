# Assets (should have the loweest priority)
ReportWorker::Parser.add(ReportWorker::Parser::Asset::Computer, 10)

# Components (should have a middle priority as they require assets)
ReportWorker::Parser.add(ReportWorker::Parser::Component::Cpu, 20)
ReportWorker::Parser.add(ReportWorker::Parser::Component::Nic, 20)
ReportWorker::Parser.add(ReportWorker::Parser::Component::RamModule, 20)

# Statuse (should have the highest priority as they require assets and components)
ReportWorker::Parser.add(ReportWorker::Parser::Status::CpuTemperature, 50)
