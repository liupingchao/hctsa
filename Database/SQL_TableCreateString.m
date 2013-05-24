function CreateString = SQL_TableCreateString(whattable)
% Determines the appropriate mySQL CREATE TABLE statement to use to create a given table, identified by the input string, whattable
% Ben Fulcher, May 2013

switch whattable
case 'Operations'
    CreateString = ['CREATE TABLE Operations ' ...
        '(m_id INTEGER NOT NULL AUTO_INCREMENT, ' ... % Unique integer identifier
        'OpName VARCHAR(255), ' ... % Unique name for the operation
        'MasterLabel VARCHAR(255), ' ... % Label of master code
        'Pointer TINYINT(1), ' ... % perhaps redundant given MasterLabel
        'Code VARCHAR(255), ' ... % Code to execute, or Master to retrieve from
        'Keywords VARCHAR(255), ' ... % Comma separated keyword metadata
        'CanDistribute INTEGER UNSIGNED, ' ... % Code for whether safe to distribute
        'LicenseType INTEGER UNSIGNED, ' ... % License for the code
        'Stochastic TINYINT(1), ' ... % Boolean identifier: is it a stochastic algorithm?
        'LastModified DATETIME, ' ... % Last modified
        'PRIMARY KEY (m_id))']; % sets primary key as m_id
        
case 'TimeSeries'
    CreateString = ['CREATE TABLE TimeSeries ' ...
        '(ts_id INTEGER NOT NULL AUTO_INCREMENT, ' ... % Unique integer identifier
        'Filename VARCHAR(255), ' ... % FileName of the time series
        'Keywords VARCHAR(255), ' ... % Comma-delimited keywords assigned to the time series
        'Length INTEGER UNSIGNED, ' ... % Length of the time series
        'SamplingRate FLOAT, ' ... % Sampling rate of the time series
        'IsSynthetic TINYINT(1), ' ... % Boolean identifier of time series that are created from time-series models
        'SourceName VARCHAR(255), ' ... % Where the time series was sourced from
        'SourceLink VARCHAR(255), ' ... % (URL) link to time series source
        'CanDistribute INTEGER UNSIGNED, ' ... % Code informing distribution
        'LastModified DATETIME, ' ... % Time stamp of when the time series was last modified
        'PRIMARY KEY (ts_id))']; % Make reference to the primary key, ts_id
        
case 'MasterOperations'
    CreateString = ['CREATE TABLE MasterOperations ' ...
        '(Master_id INTEGER NOT NULL AUTO_INCREMENT, ' ... % Unique integer identifier
        'MasterLabel VARCHAR(255), ' ... % Name given to master code file
        'MasterCode VARCHAR(255), ' ... % Code to execute
        'NPointTo INTEGER UNSIGNED, ' ... % Number of children
        'LastModified DATETIME, ' ... % Time stamp of when entry was last modified
        'PRIMARY KEY (Master_id))']; % Set Master_id as primary key
        
case 'MasterPointerRelate'
    CreateString = ['CREATE TABLE MasterPointerRelate ' ...
        '(Master_id INTEGER, ' ... % Unique integer identifier
        'm_id INTEGER, ' ...
        'FOREIGN KEY (m_id) REFERENCES Operations(m_id) ON DELETE CASCADE ON UPDATE CASCADE, ' ...
        'FOREIGN KEY (Master_id) REFERENCES MasterOperations(Master_id) ON DELETE CASCADE ON UPDATE CASCADE)'];
        
case 'OperationKeywords'
    CreateString = ['CREATE TABLE OperationKeywords ' ...
        '(mkw_id INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY, ' ...
        'Keyword varchar(255), ' ...
        'NumOccur INTEGER, ' ...
        'PercentageCalculated FLOAT, ' ...
        'PercentageGood FLOAT, ' ...
        'MeanCalcTime FLOAT)'];
        
case 'mkwFileRelate'
    CreateString = ['CREATE TABLE mkwFileRelate ' ...
        '(mkw_id INTEGER, m_id INTEGER, '  ...
        'FOREIGN KEY (mkw_id) REFERENCES OperationKeywords (mkw_id) ON DELETE CASCADE ON UPDATE CASCADE, ' ...
        'FOREIGN KEY (m_id) REFERENCES Operations (m_id) ON DELETE CASCADE ON UPDATE CASCADE)'];
        
case 'TimeSeriesKeywords'
    CreateString = ['CREATE TABLE TimeSeriesKeywords ' ...
        '(tskw_id INTEGER AUTO_INCREMENT PRIMARY KEY, ' ...
        'Keyword varchar(50), ' ...
        'NumOccur INTEGER, ' ...
        'MeanLength INTEGER)'];
        
case 'tskwFileRelate'
    CreateString = ['CREATE TABLE tskwFileRelate ' ...
        '(tskw_id INTEGER, ' ...
        'ts_id INTEGER, ' ...
        'FOREIGN KEY (tskw_id) REFERENCES TimeSeriesKeywords(tskw_id) ON DELETE CASCADE ON UPDATE CASCADE, ' ...
        'FOREIGN KEY (ts_id) REFERENCES TimeSeries(ts_id) ON DELETE CASCADE ON UPDATE CASCADE)'];
        
case 'Results'
    CreateString = ['CREATE TABLE Results ' ...
        '(ts_id integer, ' ...
        'm_id INTEGER, ' ...
        'Output DOUBLE, ' ...
        'Quality INTEGER UNSIGNED, ' ...
        'CalculationTime FLOAT, ' ...
        'LastModified DATETIME, ' ...
        'FOREIGN KEY (ts_id) REFERENCES TimeSeries (ts_id) ON DELETE CASCADE ON UPDATE CASCADE, ' ...
        'FOREIGN KEY (m_id) REFERENCES Operations (m_id) ON DELETE CASCADE ON UPDATE CASCADE, '...
        'PRIMARY KEY(ts_id,m_id) )'];
        
otherwise
    error(['Unknown table ' whattable]) 
end

end